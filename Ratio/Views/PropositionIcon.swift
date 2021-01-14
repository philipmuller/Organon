//
//  PropositionIcon.swift
//  Ratio
//
//  Created by Philip Müller on 09/11/2020.
//

import SwiftUI

struct PropositionIcon: View {
    let state: Bool
    let proposition: Proposition
    
    var body: some View {
        ZStack {
            let background = RoundedRectangle(cornerRadius: 3)
                .foregroundColor(boxColor(type: proposition.type))
    
            Text(justificationText(proposition: proposition, state: state))
                .padding(EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5))
                .background(background)
                .font(.custom("AvenirNext-DemiBold", size: 12))
                .foregroundColor(.white)
        }
    }
    
    func justificationText(proposition: Proposition, state: Bool) -> String {
        if let j = proposition.justification {
            if let references = j.references {
                if state == true {
                    if let eText = j.type?.extendedText() {
                        return references.count < 2 ? eText + ": \(references.first!)" : eText + ": \(references.first!), \(references.last!)"
                    }
                } else {
                    if let cText = j.type?.text() {
                        return cText
                    }
                }
            }
            if let type = j.type {
                return state ? type.extendedText() : type.text()
            }
        }
        
        return state ? "Premise" : "Pr"
    }
    
    func boxColor(type: PropositionType) -> Color {
        switch type {
        case .conclusion:
            return Color("Conclusion")
        case .premise:
            return Color("Premise")
        case .step:
            return Color("BoxGrey")
        default:
            return Color("BoxGrey")
        }
    }
}

struct PropositionIcon_Previews: PreviewProvider {
    static var previews: some View {
        PropositionIcon(state: false, proposition: Proposition(content: Statement(text: "bla", symbol: "B"), type: .premise))
    }
}
