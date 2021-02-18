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
        TabView {
            NavigationView {
                ArgumentBrowser(arguments: [firstArgument, secondArgument, thirdArgument, fourthArgument, fifthArgument])
                //ArgumentView(argument: giveMeWhatIWant())
            }
            .tabItem {
                VStack {
                    Image("ragionamenti").font(.system(size: 23))
                    Text("Ragionamenti")
                }
                .background(Color.red)
                
                
            }
            
            NavigationView {
                CompendiumBrowser()
            }
            .tabItem {
                VStack {
                    Image("libreria").font(.system(size: 23))
                    Text("Libreria")
                }
                .background(Color.red)

                
                
            }
        }
        
    }
    
    var firstArgument: Argument {
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
        
        let prop = [first, second, third, fourth, fifth, sixth, seventh, eight, ninth, tenth, eleventh, twelfth]//.shuffled()
        
        let argument = Argument(title: "Stupidity doesn't justify killing", propositions: prop)
        argument.description = "This is not an argument for veganism. This is an argument that wants to illustrate how the common justification for killing animals because they are stupid is inconsistent."
        return argument
    }
    
    var secondArgument: Argument {
        let b = Statement(content: "Everything in the Bible is true", formula: "B")
        let w = Statement(content: "The world was created in seven days", formula: "W")
        
        //First proposition
        let ifBthenW = Conditional(b, w)
        
        let first = Proposition(content: ifBthenW.copy(), type: .premise, position: 1)
        
        //Second proposition
        let notW = Negation(w)
        let second = Proposition(content: notW.copy(), type: .premise)
        
        let notB = Negation(b)
        let third = Proposition(content: notB.copy(), type: .conclusion)
        
        let prop = [first, second, third]//.shuffled()
        
        let argument = Argument(title: "The Bible is not inerrant", propositions: prop)
        argument.description = "Of course, some version of inerrancy might escape this argument. Premise 1 might need further clarification and defence."
        return argument
    }
    
    var thirdArgument: Argument {
        let d = Statement(content: "X is demonstrated", formula: "D")
        let b = Statement(content: "It is possible to rationally believe X", formula: "B")
        
        //First proposition
        let notD = Negation(d)
        let first = Proposition(content: notD.copy(), type: .premise)
        
        //Second proposition
        let second = Proposition(content: b.copy(), type: .premise)
        
        //Third proposition
        let ifNotDthenNotB = Conditional(notD, Negation(b))
        let third = Proposition(content: ifNotDthenNotB.copy(), type: .step, justification: Justification(type: .AIP))
        
        //Fourth proposition
        let fourth = Proposition(content: d.copy(), type: .step, justification: Justification(type: .MT, references: [second.id, third.id]))
        
        //Fith proposition
        let contradiction = Conjunction(notD, d)
        let fifth = Proposition(content: contradiction.copy(), type: .step, justification: Justification(type: .CN, references: [first.id, fourth.id]))
        
        //Sixth proposition
        let notifnotDthennotB = Negation(ifNotDthenNotB)
        let sixth = Proposition(content: notifnotDthennotB.copy(), type: .conclusion, justification: Justification(type: .IP, references: [third.id, fifth.id]))
        
        let prop = [first, second, third, fourth, fifth, sixth]//.shuffled()
        
        let argument = Argument(title: "Rational belief can be justified even without demonstration", propositions: prop)
        argument.description = "A very common argument by atheists that I find irritating. Here is why it doesn't work."
        return argument
    }
    
    var fourthArgument: Argument {
        let d = Statement(content: "Death is to be deprived of all sensation", formula: "D")
        let s = Statement(content: "Death is like a dreamless sleep", formula: "S")
        let f = Statement(content: "Death shouldn’t be feared", formula: "F")
        
        //First proposition
        let first = Proposition(content: d.copy(), type: .premise)
        
        //Second proposition
        let ifDthenS = Conditional(d, s)
        let second = Proposition(content: ifDthenS.copy(), type: .premise)
        
        //Third proposition
        let ifSthenF = Conditional(s, f)
        let third = Proposition(content: ifSthenF.copy(), type: .premise)
        
        //Fourth proposition
        let ifDthenF = Conditional(d, f)
        let fourth = Proposition(content: ifDthenF.copy(), type: .step, justification: Justification(type: .HS, references: [second.id, third.id]))
        
        //Fith proposition
        let fifth = Proposition(content: f.copy(), type: .conclusion, justification: Justification(type: .MP, references: [first.id, fourth.id]))
        
        let prop = [first, second, third, fourth, fifth]//.shuffled()
        
        let argument = Argument(title: "Death shouldn't be feared", propositions: prop)
        return argument
    }
    
    var fifthArgument: Argument {
        let g = Statement(content: "God exists", formula: "G")
        let r = Statement(content: "There are nonresistant nonbelievers", formula: "R")
        
        //First proposition
        let notR = Negation(r)
        let ifGthenNotR = Conditional(g, notR)
        let first = Proposition(content: ifGthenNotR.copy(), type: .premise)
        
        //Second proposition
        let second = Proposition(content: r.copy(), type: .premise)
        
        //Third proposition
        let notG = Negation(g)
        let third = Proposition(content: notG.copy(), type: .conclusion, justification: Justification(type: .MT, references: [first.id, second.id]))
        
        let prop = [first, second, third]//.shuffled()
        
        let argument = Argument(title: "The hiddenness argument", propositions: prop)
        return argument
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



