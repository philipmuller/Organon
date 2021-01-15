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
                .font(.custom("AvenirNext-Medium", size: 18))
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
        
        let second = Proposition(content: notIfSandHthenK.copy(), type: .premise)
        
        //Third proposition
        let sAndA = Conjunction(s, a)
        let ifSandAthenK = Conditional(sAndA, k)
        
        let third = Proposition(content: ifSandAthenK.copy(), type: .step, justification: Justification(type: .AIP))
        
        //Fourth proposition
        let fourth = Proposition(content: sAndH.copy(), type: .step, justification: Justification.init(type: .ACP))
        
        //Fifth proposition
        let fifth = Proposition(content: s.copy(), type: .step, justification: Justification(type: .SM, references: [fourth.id]))
        
        //Sixth proposition
        let sixth = Proposition(content: h.copy(), type: .step, justification: Justification(type: .SM, references: [fourth.id]))
        
        //Seventh proposition
        let seventh = Proposition(content: a.copy(), type: .step, justification: Justification(type: .MP, references: [first.id, sixth.id]))
        
        //Eight proposition
        let eight = Proposition(content: sAndA.copy(), type: .step, justification: Justification(type: .CN, references: [fifth.id, seventh.id]))
        
        //Ninth proposition
        let ninth = Proposition(content: k.copy(), type: .step, justification: Justification(type: .MP, references: [third.id, eight.id]))
        
        //Tenth proposition
        let tenth = Proposition(content: ifSandHthenK.copy(), type: .step, justification: Justification(type: .CP, references: [fourth.id, ninth.id]))
        
        //Eleventh proposition
        let contradiction = Conjunction(notIfSandHthenK, ifSandHthenK)
        let eleventh = Proposition(content: contradiction.copy(), type: .step, justification: Justification(type: .CN, references: [second.id, tenth.id]))
        
        //Twelfth proposition
        let notIfSandAthenK = Negation(ifSandAthenK)
        let twelfth = Proposition(content: notIfSandAthenK.copy(), type: .conclusion, justification: Justification(type: .IP, references: [third.id, eleventh.id]), alias: "Therefore, it is not the case that if an animal is stupid, it can be ethically killed for food")
        
        return [first, second, third, fourth, fifth, sixth, seventh, eight, ninth, tenth, eleventh, twelfth]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



