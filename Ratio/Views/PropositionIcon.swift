//
//  PropositionIcon.swift
//  Ratio
//
//  Created by Philip Müller on 09/11/2020.
//

import SwiftUI

struct PropositionIcon: View {
    let state: Bool
    let type: PropositionType
    let justification: (Justification?, [Int]?)
    
    var body: some View {
        ZStack {
            let background = RoundedRectangle(cornerRadius: 3)
                .foregroundColor(boxColor(type: type))
    
            Text(justificationText(data: justification, state: state))
                .padding(EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5))
                .background(background)
                .font(.custom("AvenirNext-DemiBold", size: 12))
                .foregroundColor(.white)
        }
    }
    
    func justificationText(data: (Justification?, [Int]?), state: Bool) -> String {
        if let j = data.0 {
            if let r = data.1 {
                if state == true {
                    if let eText = j.type?.extendedText() {
                        return r.count < 2 ? eText + ": \(r.first!)" : eText + ": \(r.first!), \(r.last!)"
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
        Text("Not available ATM")
        //PropositionIcon(state: false, proposition: Proposition(content: Statement(content: "bla", formula: "B"), type: .premise))
    }
}
