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
                ArgumentBrowser(arguments: [seventhArgumentITA, firstArgumentITA, eigthArgumentITA, secondArgumentITA, fourthArgumentITA, fifthArgumentITA, sixthArgumentITA])
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
                    Text("Biblioteca")
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
    
    var firstArgumentITA: Argument {
        let h = Statement(content: "Il soggetto è un cane", formula: "H")
        let a = Statement(content: "Il soggetto è un animale", formula: "A")
        let s = Statement(content: "Il soggetto è stupido", formula: "S")
        let k = Statement(content: "Il soggetto può essere mangiato eticamente", formula: "K")
        
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
        let twelfth = Proposition(content: notIfSandAthenK.copy(), type: .conclusion, justification: Justification(type: .IP, references: [third.id, eleventh.id]))
        
        let prop = [first, second, third, fourth, fifth, sixth, seventh, eight, ninth, tenth, eleventh, twelfth]//.shuffled()
        
        let argument = Argument(title: "Mangiare animali perché stupidi non è giustificato", propositions: prop)
        argument.description = "Questo non è un ragionamento diretto per il veganesimo, ma dimostra che la stupidità degli animali non è giustificazione sufficiente per mangiarli."
        return argument
    }
    
    var secondArgumentITA: Argument {
        let b = Statement(content: "Tutto il contenuto della Bibbia è vero", formula: "B")
        let w = Statement(content: "L'universo è stato creato in sette giorni", formula: "W")
        
        //First proposition
        let ifBthenW = Conditional(b, w)
        
        let first = Proposition(content: ifBthenW.copy(), type: .premise, position: 1)
        
        //Second proposition
        let notW = Negation(w)
        let second = Proposition(content: notW.copy(), type: .premise)
        
        let notB = Negation(b)
        let third = Proposition(content: notB.copy(), type: .conclusion)
        
        let prop = [first, second, third]//.shuffled()
        
        let argument = Argument(title: "La Bibbia non è inerrante", propositions: prop)
        argument.description = "Questo ragionamento affronta solo interpretazioni letterali di inerrante. La Bibbia potrebbe essere comunque inerrante in interpretazioni non-letterali."
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
    
    var fourthArgumentITA: Argument {
        let d = Statement(content: "La morte è la deprivazione di tutti i sensi", formula: "D")
        let s = Statement(content: "La morte è come un sonno senza sogni", formula: "S")
        let f = Statement(content: "La morte non va temuta", formula: "F")
        
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
        
        let argument = Argument(title: "La morte non va temuta", propositions: prop)
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
    
    var fifthArgumentITA: Argument {
        let g = Statement(content: "Dio esiste", formula: "G")
        let r = Statement(content: "Esistono persone non-credenti aperte ad una relazione con dio", formula: "R")
        
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
        
        let argument = Argument(title: "J. L. Schellenberg", propositions: prop)
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
    
    var sixthArgumentITA: Argument {
        let l = Statement(content: "Siamo atterrati sulla luna", formula: "D")
        let a = Statement(content: "I video dell’atterraggio lunare sono autentici", formula: "S")
        let t = Statement(content: "Tutti gli effetti nei video dell’atterraggio lunare sono riproducibili sulla terra con le tecnologie del tempo", formula: "F")
        
        //First proposition
        let notL = Negation(l.copy())
        let notA = Negation(a.copy())
        let ifNotLThenNotA = Conditional(notL.copy(), notA.copy())
        let first = Proposition(content: ifNotLThenNotA.copy(), type: .premise)
        
        //Second proposition
        let ifNotAthenT = Conditional(notA.copy(), t.copy())
        let second = Proposition(content: ifNotAthenT.copy(), type: .premise)
        
        //Third proposition
        let notT = Negation(t.copy())
        let third = Proposition(content: notT.copy(), type: .premise)
        
        //Fourth proposition
        let ifNotLthenT = Conditional(notL.copy(), t.copy())
        let fourth = Proposition(content: ifNotAthenT.copy(), type: .step, justification: Justification(type: .HS, references: [first.id, second.id]))
        
        //Fith proposition
        let fifth = Proposition(content: l.copy(), type: .conclusion, justification: Justification(type: .MT, references: [third.id, fourth.id]))
        
        let prop = [first, second, third, fourth, fifth]//.shuffled()
        
        let argument = Argument(title: "Apollo", propositions: prop)
        return argument
    }
    
    var seventhArgumentITA: Argument {
        let a = Statement(content: "Colonnello Mustard è l'assassino", formula: "D")
        let i = Statement(content: "Colonnello Mustard indossava questi guanti", formula: "S")
        let g = Statement(content: "Colonnello Mustard è in grado di indossare questi guanti", formula: "F")
        
        //First proposition
        let notA = Negation(a.copy())
        let ifAThenI = Conditional(a.copy(), i.copy())
        let first = Proposition(content: ifAThenI.copy(), type: .premise)
        
        //Second proposition
        let ifIthenG = Conditional(i.copy(), g.copy())
        let second = Proposition(content: ifIthenG.copy(), type: .premise)
        
        //Third proposition
        let notG = Negation(g.copy())
        let third = Proposition(content: notG.copy(), type: .premise)
        
        //Fourth proposition
        let notI = Negation(i.copy())
        let fourth = Proposition(content: notI.copy(), type: .step, justification: Justification(type: .MT, references: [second.id, third.id]))
        
        //Fith proposition
        let fifth = Proposition(content: notA.copy(), type: .conclusion, justification: Justification(type: .MT, references: [fourth.id, first.id]))
        
        let prop = [first, second, third, fourth, fifth]//.shuffled()
        
        let argument = Argument(title: "Il colonnello è innocente", propositions: prop)
        return argument
    }
    
    var eigthArgumentITA: Argument {
        let de = Statement(content: "Dio esiste", formula: "H")
        let d0 = Statement(content: "Dio è onnipotente", formula: "A")
        let mp = Statement(content: "Dio è moralmente perfetto", formula: "S")
        let prm = Statement(content: "Dio ha il potere di rimuovere il male", formula: "K")
        let drm = Statement(content: "Dio ha il desiderio di rimuovere il male", formula: "K")
        let me = Statement(content: "Il male esiste", formula: "K")
        
        let first = Proposition(content: Conditional(de.copy(), Conjunction(d0.copy(), mp.copy())), type: .premise)
        let second = Proposition(content: Conditional(d0.copy(), prm.copy()), type: .premise)
        let third = Proposition(content: Conditional(mp.copy(), drm.copy()), type: .premise)
        let fourth = Proposition(content: Conditional(Conjunction(prm.copy(), drm.copy()), Negation(me.copy())), type: .premise)
        let fifth = Proposition(content: me.copy(), type: .premise)
        
        let sixth = Proposition(content: de.copy(), type: .step, justification: Justification(type: .AIP))
        let seventh = Proposition(content: Conjunction(d0.copy(), mp.copy()), type: .step, justification: Justification(type: .MP, references: [first.id, sixth.id]))
        let eighth = Proposition(content: mp.copy(), type: .step, justification: Justification(type: .SM, references: [seventh.id]))
        let ninth = Proposition(content: drm.copy(), type: .step, justification: Justification(type: .MP, references: [third.id, eighth.id]))
        let tenth = Proposition(content: d0.copy(), type: .step, justification: Justification(type: .SM, references: [seventh.id]))
        let eleventh = Proposition(content: prm.copy(), type: .step, justification: Justification(type: .MP, references: [second.id, tenth.id]))
        let twelvth = Proposition(content: Conjunction(prm.copy(), drm.copy()), type: .step, justification: Justification(type: .CN, references: [eleventh.id, ninth.id]))
        let thirtinth = Proposition(content: Negation(me.copy()), type: .step, justification: Justification(type: .MP, references: [fourth.id, twelvth.id]))
        let fourteenth = Proposition(content: Conjunction(Negation(me.copy()), me.copy()), type: .step, justification: Justification(type: .CN, references: [fifth.id, thirtinth.id]))
        let fifteenth = Proposition(content: Negation(de.copy()), type: .conclusion, justification: Justification(type: .IP, references: [sixth.id, fourteenth.id]))
        
        
        let prop = [first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth, eleventh, twelvth, thirtinth, fourteenth, fifteenth]//.shuffled()
        
        let argument = Argument(title: "Il problema del male", propositions: prop)
        return argument
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



