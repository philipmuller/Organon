//
//  PropositionView.swift
//  Ratio
//
//  Created by Philip Müller on 09/11/2020.
//

import SwiftUI

struct PropositionView: View {
    let proposition: Proposition
    @Namespace var namespace
    
    
    let expanded: Bool
    let faded: Bool
    let editable: Bool
    
    @State var count = 0
    
    var body: some View {
        HStack(alignment: .top) {
            if !expanded {
                iconAndNumber
            }
            VStack(alignment: .leading) {
                if expanded {
                    iconAndNumber
                }
                propositionView
                    .padding(.top, expanded ? 7 : 0)
            }
        }
        .padding(.all, expanded ? 20 : 0)
        .frame(minWidth: expanded ? 350 : 0, maxWidth: 350, alignment: .leading)
        .background(generateBackground(expanded: expanded))
        .opacity(faded ? 0.2 : 1)
        //.animation(.default)
    }
    
    var propositionView: some View {
        return VStack(alignment: .leading, spacing: 5) {
            StatementView(statement: proposition.content, deleteCount: $count, editable: editable)
            
            propositionDetailView
                .frame(width: expanded ? nil : 0, height: expanded ? nil : 0)
        }
    }
    
    var propositionDetailView: some View {
        VStack(alignment: .leading){
            Divider()
                .padding(.bottom, 15)
            if let alias = proposition.alias {
                Text("\"" + alias + "\"")
                    .font(.custom("SabonItalic", size: 14))
                    .foregroundColor(Color("MainText"))
                    .opacity(0.8)
                    .padding(.bottom, 8)
            }
            formula
        }
    }
    
    var formula: some View {
        HStack(alignment: .firstTextBaseline) {
            
            Text("FORMULA: ")
                .font(.custom("AvenirNext-Medium", size: 14))
                .foregroundColor(Color("BoxGrey"))
            
            Group {
                if let cStatement = proposition.content as? ComplexStatement {
                    switch cStatement.csType {
                    case .ifthen:
                        (cStatement.childStatements.first! > cStatement.childStatements.last!).1
                    case .and:
                        (cStatement.childStatements.first! > cStatement.childStatements.last!).1
                    case .or:
                        (cStatement.childStatements.first! > cStatement.childStatements.last!).1
                    case .negation:
                        (~cStatement.childStatements.first!).1
                    }
                } else {
                    Text(proposition.content.symbol!)
                }
            }.font(.custom("SabonBold", size: 18))
            
        }
    }
    
    var iconAndNumber: some View {
        HStack {
            if expanded {
                Text("\(proposition.number).")
                    .matchedGeometryEffect(id: "number", in: namespace)
                    .opacity(0.3)
                    .alignmentGuide(.basePropositionAlignment) { d in
                        -indent(proposition: proposition)
                    }
                
                PropositionIcon(state: expanded, proposition: proposition)
                    .matchedGeometryEffect(id: "icon", in: namespace)
                    .anchorPreference(key: PropositionPreferenceKey.self, value: .bounds) {
                        return [PropositionPreferenceData(bounds: $0, proposition: proposition)]
                    }
                
            } else {
                PropositionIcon(state: expanded, proposition: proposition)
                    .matchedGeometryEffect(id: "icon", in: namespace)
                    .anchorPreference(key: PropositionPreferenceKey.self, value: .bounds) {
                        return [PropositionPreferenceData(bounds: $0, proposition: proposition)]
                    }
                
                Text("\(proposition.number).")
                    .matchedGeometryEffect(id: "number", in: namespace)
                    .opacity(0.3)
                    .alignmentGuide(.basePropositionAlignment) { d in
                        -indent(proposition: proposition)
                    }
            }
            
        }
    }
    
    func generateBackground(expanded: Bool) -> some View {
        return RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.white).opacity(expanded ? 1 : 0)
            .shadow(color: Color("BoxGrey"), radius: expanded ? 10 : 0)
    }
    
    func indent(proposition: Proposition) -> CGFloat {
        return CGFloat(proposition.level * 30)
    }
    
}

struct PropositionView_Previews: PreviewProvider {
    static var previews: some View {
        
        let sl = Statement(text: "Socrates is lying", symbol: "L")
        let sr = Statement(text: "Socrates is reasonable", symbol: "R")
        let pw = Statement(text: "Plato is wrong", symbol: "P")
        let aw = Statement(text: "Aristotele is wrong", symbol: "A")
        
        let conditional = ComplexStatement(type: .ifthen, blocks: [Statement(pw), Statement(aw)])
        let conditional2 = ComplexStatement(type: .ifthen, blocks: [Statement(sl), Statement(sr)])
        let conjunction2 = ComplexStatement(type: .and, blocks: [ComplexStatement(conditional), Statement(sl)])
        let negation = ComplexStatement(type: .negation, blocks: [ComplexStatement(conjunction2)])
        let conjunction = ComplexStatement(type: .and, blocks: [ComplexStatement(conditional), ComplexStatement(negation)])
        let newNegation = ComplexStatement(type: .negation, blocks: [ComplexStatement(conjunction)])
        
        let disjunction = ComplexStatement(type: .or, blocks: [Statement(sl), ComplexStatement(conjunction)])
        
       
        
        let sNegation = ComplexStatement(type: .negation, blocks: [aw])
        let lConditional = ComplexStatement(type: .ifthen, blocks: [sl, sr])
        
        let hConditional = ComplexStatement(type: .ifthen, blocks: [lConditional, disjunction])
        //let negation = ComplexStatement(type: .negation, blocks: [hConditional])
        
        //(StatementView(statement: sNegation) + StatementView(statement: disjunction)).0
        
        PropositionView(proposition: Proposition(content: disjunction, type: .step, justification: Justification(type: .MT, references: [1, 2])), expanded: false, faded: false, editable: false).accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    }
}
