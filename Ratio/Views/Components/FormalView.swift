//
//  FormalArgumentView.swift
//  Ratio
//
//  Created by Philip Müller on 07/11/2020.
//

import SwiftUI

struct FormalView: View {
    
    @Binding var formalData: FormalData
    @Binding var selectedProposition: Proposition?
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack(alignment: selectedProposition == nil ? .basePropositionAlignment : .leading, spacing: 20) {
            let somethingSelected = selectedProposition != nil ? true : false
            Print(formalData.numberOfSteps)
            ForEach(formalData.propositions) { proposition in
                Print(index)
                let selected = selectedProposition?.id == proposition.id ? true : false
                let faded = !somethingSelected || ((selectedProposition?.justification?.references?.first == formalData.propositions.firstIndex(of: proposition) || selectedProposition?.justification?.references?.last == formalData.propositions.firstIndex(of: proposition)) || selected) ? false : true
                
                PropositionView(proposition: $formalData.propositions[formalData.propositions.firstIndex(of: proposition) ?? 0], propositions: $formalData.propositions, onDelete: removeRows(at:), position: formalData.position(of: proposition), level: formalData.level(of: proposition), expanded: selected, faded: faded, editable: selected ? isEditing : false)
                    .onTapGesture {
                        withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 0.7, damping: 1.2, initialVelocity: 0.5).speed(10)) {
                            if selectedProposition?.id == proposition.id {
                                isEditing = true
                            } else {
                                selectedProposition = proposition
                                isEditing = false
                            }
                        }
                    }
                    .alignmentGuide(HorizontalAlignment.leading) { d in
                        return (selectedProposition?.id == proposition.id || (selectedProposition?.justification?.references?.first == formalData.propositions.firstIndex(of: proposition) || selectedProposition?.justification?.references?.last == formalData.propositions.firstIndex(of: proposition))) ? d[HorizontalAlignment.leading] : d[HorizontalAlignment.leading] - 60
                    }
            }.onDelete(perform: removeRows(at:))
        }
        .backgroundPreferenceValue(PropositionPreferenceKey.self) { preferences in
            GeometryReader { geometry in
                LBracketView(geometry: geometry, preferences: preferences)
                    .opacity(selectedProposition == nil ? 1 : 0)
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        withAnimation {
            formalData.propositions.remove(atOffsets: offsets)
        }
    }
}

extension HorizontalAlignment {
    enum BasePropositionAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.leading]
        }
    }
    
    static let basePropositionAlignment = HorizontalAlignment(BasePropositionAlignment.self)
}

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

struct PropositionPreferenceData: Identifiable {
    let id = UUID()
    let bounds: Anchor<CGRect>
    let proposition: Proposition
}

struct PropositionPreferenceKey: PreferenceKey {
    typealias Value = [PropositionPreferenceData]
    
    static var defaultValue: [PropositionPreferenceData] = []
    
    static func reduce(value: inout [PropositionPreferenceData], nextValue: () -> [PropositionPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}



struct FormalArgumentView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Text("Nothing to see here")
        }
    }
}
