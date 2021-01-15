//
//  ContentView.swift
//  Ratio
//
//  Created by Philip Müller on 07/11/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            let argument = Argument(title: "Stupidity doesn't justify killing", propositions: generatePropositions())
            ArgumentView(argument: argument)
        }
    }
    
    func generatePropositions() -> [Proposition] {
        let h = Statement(content: "Something is a human", formula: "H")
        let a = Statement(content: "Something is an animal", formula: "A")
        let s = Statement(content: "Something is stupid", formula: "S")
        let k = Statement(content: "Something can be ethically killed for food", formula: "K")
        
        //First proposition
        let ifHthenA = Conditional(h, a)
        
        let first = Proposition(content: ifHthenA.copy(), type: .premise, position: 1)
        
        //Second proposition
        let sAndH = Conjunction(s, h)
        let ifSandHthenK = Conditional(sAndH, k)
        let notIfSandHthenK = Negation(ifSandHthenK)
        
        let second = Proposition(content: notIfSandHthenK.copy(), type: .premise, position: 2)
        
        //Third proposition
        let sAndA = Conjunction(s, a)
        let ifSandAthenK = Conditional(sAndA, k)
        
        let third = Proposition(content: ifSandAthenK.copy(), type: .step, justification: Justification(type: .AIP), position: 3)
        
        //Fourth proposition
        let fourth = Proposition(content: sAndH.copy(), type: .step, justification: Justification.init(type: .ACP), position: 4)
        
        //Fifth proposition
        let fifth = Proposition(content: s.copy(), type: .step, justification: Justification(type: .SM, references: [4]), position: 5)
        
        //Sixth proposition
        let sixth = Proposition(content: h.copy(), type: .step, justification: Justification(type: .SM, references: [4]), position: 6)
        
        //Seventh proposition
        let seventh = Proposition(content: a.copy(), type: .step, justification: Justification(type: .MP, references: [1, 6]), position: 7)
        
        //Eight proposition
        let eight = Proposition(content: sAndA.copy(), type: .step, justification: Justification(type: .CN, references: [5, 7]), position: 8)
        
        //Ninth proposition
        let ninth = Proposition(content: k.copy(), type: .step, justification: Justification(type: .MP, references: [3, 8]), position: 9)
        
        //Tenth proposition
        let tenth = Proposition(content: ifSandHthenK.copy(), type: .step, justification: Justification(type: .CP, references: [4, 9]), position: 10)
        
        //Eleventh proposition
        let contradiction = Conjunction(notIfSandHthenK, ifSandHthenK)
        let eleventh = Proposition(content: contradiction.copy(), type: .step, justification: Justification(type: .CN, references: [2, 10]), position: 11)
        
        //Twelfth proposition
        let notIfSandAthenK = Negation(ifSandAthenK)
        let twelfth = Proposition(content: notIfSandAthenK.copy(), type: .conclusion, justification: Justification(type: .IP, references: [3, 11]), position: 12, alias: "Therefore, it is not the case that if an animal is stupid, it can be ethically killed for food")
        
        return [first, second, third, fourth, fifth, sixth, seventh, eight, ninth, tenth, eleventh, twelfth]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



