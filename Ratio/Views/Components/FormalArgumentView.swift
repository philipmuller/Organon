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
                        newProposition = Proposition(content: Statement(text: $0, symbol: "A"))
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
        //simple statements
        let h = Statement(text: "Something is a human", symbol: "H")
        let a = Statement(text: "Something is an animal", symbol: "A")
        let s = Statement(text: "Something is stupid", symbol: "S")
        let k = Statement(text: "Something can be ethically killed for food", symbol: "K")
        
        //First proposition
        let ifHthenA = ComplexStatement(type: .ifthen, blocks: [h, a])
        
        let first = Proposition(content: ifHthenA, type: .premise, position: 1)
        
        //Second proposition
        let sAndH = ComplexStatement(type: .and, blocks: [s, h])
        let ifSandHthenK = ComplexStatement(type: .ifthen, blocks: [sAndH, k])
        let notIfSandHthenK = ComplexStatement(type: .negation, blocks: [ifSandHthenK])
        
        let second = Proposition(content: notIfSandHthenK, type: .premise, position: 2)
        
        //Third proposition
        let sAndA = ComplexStatement(type: .and, blocks: [s, a])
        let ifSandAthenK = ComplexStatement(type: .ifthen, blocks: [sAndA, k])
        
        let third = Proposition(content: ifSandAthenK, type: .step, justification: Justification(type: .AIP), position: 3)
        
        //Fourth proposition
        let fourth = Proposition(content: sAndH, type: .step, justification: Justification.init(type: .ACP), position: 4)
        
        //Fifth proposition
        let fifth = Proposition(content: s, type: .step, justification: Justification(type: .SM, references: [4]), position: 5)
        
        //Sixth proposition
        let sixth = Proposition(content: h, type: .step, justification: Justification(type: .SM, references: [4]), position: 6)
        
        //Seventh proposition
        let seventh = Proposition(content: a, type: .step, justification: Justification(type: .MP, references: [1, 6]), position: 7)
        
        //Eight proposition
        let eight = Proposition(content: sAndA, type: .step, justification: Justification(type: .CN, references: [5, 7]), position: 8)
        
        //Ninth proposition
        let ninth = Proposition(content: k, type: .step, justification: Justification(type: .MP, references: [3, 8]), position: 9)
        
        //Tenth proposition
        let tenth = Proposition(content: ifSandHthenK, type: .step, justification: Justification(type: .CP, references: [4, 9]), position: 10)
        
        //Eleventh proposition
        let contradiction = ComplexStatement(type: .and, blocks: [notIfSandHthenK, ifSandHthenK])
        let eleventh = Proposition(content: contradiction, type: .step, justification: Justification(type: .CN, references: [2, 10]), position: 11)
        
        //Twelfth proposition
        let notIfSandAthenK = ComplexStatement(type: .negation, blocks: [ifSandAthenK])
        let twelfth = Proposition(content: notIfSandAthenK, type: .conclusion, justification: Justification(type: .IP, references: [3, 11]), position: 12)
        
        
        let argument = Argument(propositions: [first, second, third, fourth, fifth, sixth, seventh, eight, ninth, tenth, eleventh, twelfth])
        
            ScrollView {
               //GeometryReader { geometry in
                FormalArgumentView(propositions: [first, second, third, fourth, fifth, sixth, seventh, eight, ninth, tenth, eleventh, twelfth])
                    .padding(50)
                    
               // }
            }
    }
}
