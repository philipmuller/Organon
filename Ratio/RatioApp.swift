//
//  RatioApp.swift
//  Ratio
//
//  Created by Philip Müller on 07/11/2020.
//

import SwiftUI

@main
struct RatioApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
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
            let twelfth = Proposition(content: notIfSandAthenK, type: .conclusion, justification: Justification(type: .IP, references: [3, 11]), position: 12, alias: "Therefore, it is not the case that if an animal is stupid, it can be ethically killed for food")
            
            
            let argument = Argument(propositions: [first, second, third, fourth, fifth, sixth, seventh, eight, ninth, tenth, eleventh, twelfth])
            
            FormalArgumentView(propositions: argument.propositions)
            //TestView()
            
            //AttributedTextFromFileView(leftS: "This is cool and this is even cooler")
              //.padding(.horizontal, 40)
        }
    }
}
