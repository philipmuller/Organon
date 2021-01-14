//
//  FormalArgumentView.swift
//  Ratio
//
//  Created by Philip Müller on 07/11/2020.
//

import SwiftUI

struct FormalArgumentView: View {
    
    @State var propositions: [Proposition]
    @State var textC: String = ""
    @State var isEditing = false

    @State var selectedProposition: Proposition?
    @State var newProposition: Proposition?
    
//    init(propositions: [Proposition]) {
//        self.propositions = propositions
//    }
    
    var body: some View {
        VStack() {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        Text("Flawed justification for killing animals")
                            //.lineSpacing(10)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.custom("SabonBold", size: 30))
                            .foregroundColor(Color("MainText"))
                            .padding(.bottom, 15)
                            
                        
                        Divider()
                            
                    }
                    .padding(.bottom, 30)
                    .padding(.trailing, 80)
                    .padding(.leading, 30)
                    .padding(.top, 65)
                    
                    content
                        .padding(EdgeInsets(top: 1, leading: selectedProposition == nil ? 15 : 30, bottom: 1, trailing: selectedProposition == nil ? 55 : 30))
                        .frame(maxWidth: geometry.size.width-75)
                        .font(.custom("AvenirNext-Medium", size: 16))
                        .foregroundColor(Color("MainText"))
                        .accentColor(Color(red: 0.6, green: 0.5, blue: 0.1, opacity: 1))
                    
                    if newProposition != nil {
                        PropositionView(proposition: newProposition!, expanded: true, faded: false, editable: isEditing)
                    }
                    
                }
                
            }
            .onTapGesture {
                withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 0.7, damping: 1.2, initialVelocity: 0.5).speed(10)) {
                    selectedProposition = nil
                    isEditing = false
                }
            }
            
            let binding = Binding<String>(get: {
                        self.textC
                    }, set: {
                        self.textC = $0
                        newProposition = Proposition(content: Statement(content: $0, formula: "A"))
                        //print("\(propositions.last!.content.content)")
                    })
            
            HStack() {
                Image(systemName: "textformat")
                    .padding(.leading, 10)
                Spacer()
               
                TextField("Add or drag a step", text: binding) { isEditing in
                    self.isEditing = isEditing
                    
                } onCommit: {
                    
                    propositions.append(newProposition!)
                    newProposition = nil
                }
                
                Spacer()
                
                Image(systemName: "line.horizontal.3")
                    .padding(.trailing, 10)
            }
            .foregroundColor(Color("MainText").opacity(0.5))
            .frame(height: 35)
            .background(barBackground)
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .padding(.top, 5)
            .padding(.bottom, 5)
        }
    }
    
    var barBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color("BoxGrey").opacity(0.5))
            
            
            
    }
    
    var content: some View {
        
        
        VStack(alignment: selectedProposition == nil ? .basePropositionAlignment : .leading, spacing: 20) {
            let somethingSelected = selectedProposition != nil ? true : false
            
            ForEach(propositions, id: \.id) { proposition in
                let selected = selectedProposition?.id == proposition.id ? true : false
                let faded = !somethingSelected || ((selectedProposition?.justification?.references?.first == proposition.number || selectedProposition?.justification?.references?.last == proposition.number) || selected) ? false : true
                
                PropositionView(proposition: proposition, expanded: selected, faded: faded, editable: selected ? isEditing : false)
                    .onTapGesture {
                        withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 0.7, damping: 1.2, initialVelocity: 0.5).speed(10)) {
                            if selectedProposition?.id == proposition.id {
                                //selectedProposition = nil
                                isEditing = true
                            } else {
                                selectedProposition = proposition
                                isEditing = false
                            }
                            
                        }
                    }
                    .alignmentGuide(HorizontalAlignment.leading) { d in
                        return (selectedProposition?.id == proposition.id || (selectedProposition?.justification?.references?.first == proposition.number || selectedProposition?.justification?.references?.last == proposition.number)) ? d[HorizontalAlignment.leading] : d[HorizontalAlignment.leading] - 60
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
