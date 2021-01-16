//
//  FormalArgumentView.swift
//  Ratio
//
//  Created by Philip Müller on 07/11/2020.
//

import SwiftUI
import MobileCoreServices

struct FormalView: View {
    
    @Binding var formalData: FormalData
    @Binding var selectedProposition: Proposition?
    @Binding var isEditing: Bool
    
    var body: some View {
        //let dropDelegate = MyDropDelegate
        
        VStack(alignment: selectedProposition == nil ? .basePropositionAlignment : .leading, spacing: 20) {
            let somethingSelected = selectedProposition != nil ? true : false
            ForEach(formalData.propositions) { proposition in
                let selected = selectedProposition?.id == proposition.id ? true : false
                let faded = !somethingSelected || ((selectedProposition?.justification?.references?.first == proposition.id || selectedProposition?.justification?.references?.last == proposition.id) || selected) ? false : true
                
                PropositionView(proposition: $formalData.propositions[formalData.propositions.firstIndex(of: proposition) ?? 0], onDelete: removeView(for:), position: formalData.position(of: proposition), level: formalData.level(of: proposition), references: formalData.references(of: proposition), expanded: selected, faded: faded, editable: selected ? isEditing : false)
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
                        return (selectedProposition?.id == proposition.id || (selectedProposition?.justification?.references?.first == proposition.id || selectedProposition?.justification?.references?.last == proposition.id)) ? d[HorizontalAlignment.leading] : d[HorizontalAlignment.leading] - 60
                    }
                    .anchorPreference(key: PropositionPreferenceKey.self, value: .bounds) {
                        return [PropositionPreferenceData(bounds: $0, id: proposition.id)]
                    }
                    
            }
            
        }
        .onDrop(of: [kUTTypeData as String], delegate: formalData)
        .backgroundPreferenceValue(PropositionPreferenceKey.self) { preferences in
            GeometryReader { geometry in
                Text("")
                    .onAppear(perform: {
                        formalData.updatePropositionBounds(with: preferences, context: geometry)
                    })
            }
        }
        .backgroundPreferenceValue(TagPreferenceKey.self) { preferences in
            GeometryReader { geometry in
                LBracketView(geometry: geometry, preferences: preferences)
                    .opacity(selectedProposition == nil ? 1 : 0)
            }
        }
        
        
        
        
    }
    
    func removeView(for proposition: Proposition) {
        withAnimation {
            formalData.remove(proposition: proposition)
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
    
//    func Perform(function: ([PropositionPreferenceData], GeometryProxy) -> Void) {
//        function
//        return EmptyView()
//    }
}

struct PropositionPreferenceData: Identifiable {
    let bounds: Anchor<CGRect>
    let id: UUID
    //let proposition: Proposition
}

struct PropositionPreferenceKey: PreferenceKey {
    typealias Value = [PropositionPreferenceData]
    
    static var defaultValue: [PropositionPreferenceData] = []
    
    static func reduce(value: inout [PropositionPreferenceData], nextValue: () -> [PropositionPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct TagPreferenceData: Identifiable {
    let id = UUID()
    let bounds: Anchor<CGRect>
    let proposition: Proposition
}

struct TagPreferenceKey: PreferenceKey {
    typealias Value = [TagPreferenceData]
    
    static var defaultValue: [TagPreferenceData] = []
    
    static func reduce(value: inout [TagPreferenceData], nextValue: () -> [TagPreferenceData]) {
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
