//
//  FormalArgumentView.swift
//  Ratio
//
//  Created by Philip Müller on 07/11/2020.
//

import SwiftUI

struct FormalView: View {
    
    @Binding var propositions: [Proposition]
    @Binding var selectedProposition: Proposition?
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack(alignment: selectedProposition == nil ? .basePropositionAlignment : .leading, spacing: 20) {
            let somethingSelected = selectedProposition != nil ? true : false
            
            ForEach(0..<propositions.count) { index in
                let selected = selectedProposition?.id == propositions[index].id ? true : false
                let faded = !somethingSelected || ((selectedProposition?.justification?.references?.first == propositions[index].number || selectedProposition?.justification?.references?.last == propositions[index].number) || selected) ? false : true
                
                PropositionView(proposition: $propositions[index], expanded: selected, faded: faded, editable: selected ? isEditing : false)
                    .onTapGesture {
                        withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 0.7, damping: 1.2, initialVelocity: 0.5).speed(10)) {
                            if selectedProposition?.id == propositions[index].id {
                                isEditing = true
                            } else {
                                selectedProposition = propositions[index]
                                isEditing = false
                            }
                        }
                    }
                    .alignmentGuide(HorizontalAlignment.leading) { d in
                        return (selectedProposition?.id == propositions[index].id || (selectedProposition?.justification?.references?.first == propositions[index].number || selectedProposition?.justification?.references?.last == propositions[index].number)) ? d[HorizontalAlignment.leading] : d[HorizontalAlignment.leading] - 60
                    }
            }
        }
        .backgroundPreferenceValue(PropositionPreferenceKey.self) { preferences in
            GeometryReader { geometry in
                LBracketView(geometry: geometry, preferences: preferences)
                    .opacity(selectedProposition == nil ? 1 : 0)
            }
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
