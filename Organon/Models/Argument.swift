//
//  Argument.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation
import Combine

class Argument: ObservableObject {
    var title: String
    @Published var formalData: FormalData
    @Published var sLibrary: SimpleLibrary
    
    init(title: String, propositions: [Proposition]) {
        self.title = title
        self.formalData = FormalData(propositions: propositions)
        self.sLibrary = SimpleLibrary()
        
        for proposition in formalData.propositions {
            proposition.content.setPublishClosure(closure: sLibrary.publishRequest(text:symbol:))
        }
    }
    
    
}

class SimpleLibrary: ObservableObject {
    
    @Published var statementForSymbol: [String : String] = [:]
    var symbolsForStatements: [String : String] {
        var d: [String : String] = [:]
        for (symbol, statement) in statementForSymbol {
            d[statement] = symbol
        }
        return d
    }
    var usedSymbols: [String] {
        var s: [String] = []
        
        for (symbol, _) in statementForSymbol {
            s.append(symbol)
        }
        
        return s
    }
    
    var unusedSymbols = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V", "Z", "X", "Y", "Z"]
    
    private func searchSymbolForText(_ searchText: String) -> String? {
        if searchText != "" {
            debugPrint(statementForSymbol)
            let punctuation = CharacterSet.punctuationCharacters
            let whitespace = CharacterSet.whitespaces
            let unwanted = punctuation.union(whitespace)
            
            let simplifiedSearchText = searchText.components(separatedBy: unwanted).joined().filter { $0.isASCII }
            print("Simplified search text: \(simplifiedSearchText)")
            
            for (symbol, text) in statementForSymbol {
                
                let comparisonText = text.description.components(separatedBy: unwanted).joined().filter { $0.isASCII }
                print("Comparison text: \(comparisonText)")
                print(simplifiedSearchText.compare(comparisonText, options: [.caseInsensitive]) == .orderedSame)
                if simplifiedSearchText.compare(comparisonText, options: [.caseInsensitive]) == .orderedSame {
                    return symbol
                }
            }
        }
        
        return nil
    }
    
    func newSymbol() -> String {
        let newSymbol = unusedSymbols.randomElement() ?? "Bad"
        unusedSymbols.removeAll(where: { string in
            if string == newSymbol {
                return true
            } else {
                return false
            }
        })
        
        return  newSymbol
    }
    
    
    func publishRequest(text: String, symbol: String?) {
        if let uSymbol = symbol {
            if let currentTextForSymbol = statementForSymbol[uSymbol] {
                publishPair(text: text, symbol: uSymbol)
            } else if let currentSymbolForText = searchSymbolForText(text) {
                statementForSymbol.removeValue(forKey: currentSymbolForText)
                publishPair(text: text, symbol: uSymbol)
            } else {
                publishPair(text: text, symbol: uSymbol)
            }
        } else {
            if let currentSymbolForText = searchSymbolForText(text) {
                publishPair(text: text, symbol: currentSymbolForText)
            } else {
                publishPair(text: text, symbol: newSymbol())
            }
            
        }
        
    }
    
    func publishPair(text: String, symbol: String) {
        statementForSymbol[symbol] = text
        NotificationCenter.default.post(name: .simpleStatementChange, object: (text, symbol))
    }
    
}

extension NSNotification.Name {
    static let simpleStatementChange = Notification.Name("com.ratio.simpleStatementChange")
}

class FormalData: ObservableObject {
    @Published var propositions: [Proposition]
    
    init(propositions: [Proposition]) {
        self.propositions = propositions
    }
    
    func remove(proposition: Proposition) {
        //check dependencies of thing you wish to delete
        if let dependencies = propositionsReliantOn(proposition: proposition) {
            for dependence in dependencies {
                let dependentProposition = self.proposition(for: dependence)
                let i = propositions.firstIndex(of: dependentProposition!)!
                propositions[i].justification = nil
                propositions[i].type = .premise
            }
        }
        
        
        propositions.remove(at: propositions.firstIndex(of: proposition)!)
        rearrange()
        
    }
    
    func add() {
        let newProposition = Proposition(content: Statement(content: "test", formula: "A"))
        propositions.append(newProposition)
    }
    
    func add(proposition: Proposition) {
        propositions.append(proposition)
    }
    
    func index(for proposition: Proposition) -> Int {
        return propositions.firstIndex(of: proposition)!
    }
    
    func rearrange() {
        propositions.sort(by: {
            
            switch ($0.type, $1.type) {
            case (.premise, .step):
                return true
            case (.premise, .conclusion):
                return true
            case (.premise, .premise):
                return false
            case (.step, .step):
                return false
            case (.step, .conclusion):
                return true
            case (.step, .premise):
                return false
            case (.conclusion, .step):
                return false
            case (.conclusion, .conclusion):
                return false
            case (.conclusion, .premise):
                return false
            default:
                return false
            }
            
            
            
        })
    }
    
    func position(of input: Proposition) -> Int {
        return propositions.firstIndex(of: input)! + 1
    }
    
    var numberOfSteps: Int {
        propositions.count
    }
    
    func proposition(for id: UUID) -> Proposition? {
        for proposition in propositions {
            if proposition.id == id {
                return proposition
            }
        }
        
        return nil
    }
    
    func propositionsReliantOn(proposition: Proposition) -> [UUID]? {
        if let index = propositions.firstIndex(of: proposition) {
            return dependencyMap[index]
        }
        
        return nil
    }
    
    func references(of input: Proposition) -> [Int]? {
        if let idReferences = input.justification?.references {
            var numericalReferences: [Int] = []
            for id in idReferences {
                if let desiredProposition = proposition(for: id) {
                    numericalReferences.append(position(of: desiredProposition))
                }
            }
            
            return numericalReferences
        }
        
        return nil
    }
    
    var numberOfLevels: Int {
        var levelCount = 0
        for proposition in propositions {
            if let t = proposition.justification?.type {
                if t == .ACP || t == .AIP {
                    levelCount += 1
                }
//                if t == .IP || t == .CP {
//                    indent -= 1
//                }
            }
        }
        
        return levelCount
    }
    
    var levelMap: [Int] {
        var map: [Int] = []
        var currentLevel = 0
        for proposition in propositions {
            if let t = proposition.justification?.type {
                if t == .ACP || t == .AIP {
                    currentLevel += 1
                }
                
                if t == .IP || t == .CP {
                    currentLevel -= 1
                }
            }
            
            map.append(currentLevel)
        }
        
        return map
    }
    
    var dependencyMap: [[UUID]] {
        var map: [[UUID]] = []
        for proposition in propositions {
            var dependenciesOfCurrentProposition: [UUID] = []
            for possibleDependency in propositions {
                if let ids = possibleDependency.justification?.references {
                    for id in ids {
                        if id == proposition.id {
                            dependenciesOfCurrentProposition.append(possibleDependency.id)
                        }
                    }
                }
            }
            map.append(dependenciesOfCurrentProposition)
            dependenciesOfCurrentProposition = []
        }
        
        return map
    }
    
    func boundsFor(level: Int) -> (Int, Int?)? {
        if level > numberOfLevels {
            return nil
        } else if level == 0 {
            return numberOfSteps == 0 ? nil : (1, numberOfSteps)
        } else {
            var lowerFound = false
            var upperFound = false
            var isOpen = false
            
            var count = 0
            
            var currentLevel = 0
            var lowerBound = 1
            var upperBound = numberOfSteps
            for proposition in propositions {
                count += 1
                
                if let t = proposition.justification?.type {
                    if t == .ACP || t == .AIP {
                        currentLevel += 1
                    }
                    
                    if t == .IP || t == .CP {
                        currentLevel -= 1
                    }
                }
                
                if lowerFound == false {
                    lowerBound += 1
                }
                
                if currentLevel == level {
                    lowerFound = true
                }
                
                if lowerFound == true && currentLevel < level {
                    upperFound = true
                }
                
                if upperFound == false {
                    upperBound += 1
                }
                
                if count == numberOfSteps && level == currentLevel {
                    isOpen = true
                }
            }
            
            return (lowerBound, isOpen ? nil : upperBound)
        }
    }
    
    func level(of input: Proposition) -> Int {
        let propositionIndex = propositions.firstIndex(of: input)!
        
        return levelMap[propositionIndex]
    }
    
}

extension FormalData {
    func clearHighlighting() {
        for prop in propositions {
            prop.highlight = false
        }
    }
    
    func highlightEverything() {
        for prop in propositions {
            prop.highlight = true
        }
    }
    
    func highlightAssociationCandidates() {
        for prop in propositions {
            if let js = prop.content as? JunctureStatement {
                if Statement.aS(js) != nil {
                    prop.highlight = true
                } else {
                    prop.highlight = false
                }
            } else {
                prop.highlight = false
            }
        }
    }
    
    func highlightConstructiveDilemmaCandidates() {
        var availableConjunctions: [Conjunction] = []
        var availableDisjunctions: [Disjunction] = []
        var statementsToHighlight: [Statement] = []
        
        for prop in propositions {
            if let c = prop.content as? Conjunction {
                availableConjunctions.append(c)
            }
            if let d = prop.content as? Disjunction {
                availableDisjunctions.append(d)
            }
        }
        
        for ac in availableConjunctions {
            for ad in availableDisjunctions {
                if Statement.cd(ac, ad) != nil {
                    statementsToHighlight.append(ac)
                    statementsToHighlight.append(ad)
                }
            }
        }
        
        for prop in propositions {
            for sth in statementsToHighlight {
                if prop.content == sth {
                    prop.highlight = true
                }
            }
        }
    }
    
    func highlightConjunctionsAndDisjunctions() {
        for prop in propositions {
            if prop.content.type == .disjunction || prop.content.type == .conjunction {
                prop.highlight = true
            }
        }
    }
    
    func highlightDeMorgansRuleCandidates() {
        for prop in propositions {
            if let n = prop.content as? Negation {
                if Statement.dm(n) != nil {
                    prop.highlight = true
                }
            }
            
            if let cod = prop.content as? JunctureStatement {
                if Statement.dm(cod) != nil {
                    prop.highlight = true
                }
            }
        }
    }
    
    func highlightDisjunctiveSyllogismCandidates() {
        var availableDisjunctions: [Disjunction] = []
        var statementsToHighlight: [Statement] = []
        
        for prop in propositions {
            if let d = prop.content as? Disjunction {
                availableDisjunctions.append(d)
            }
        }
        
        for ad in availableDisjunctions {
            for prop in propositions {
                if Statement.ds(ad, prop.content) != nil {
                    statementsToHighlight.append(ad)
                    statementsToHighlight.append(prop.content)
                }
            }
        }
        
        for prop in propositions {
            for sth in statementsToHighlight {
                if prop.content == sth {
                    prop.highlight = true
                }
            }
        }
    }
    
    func highlightExportationCandidates() {
        for prop in propositions {
            if let c = prop.content as? Conditional {
                if Statement.exp(c) != nil {
                    prop.highlight = true
                }
            }
        }
    }
    
    func highlightHypotheticalSyllogismCandidates() {
        var conditionals: [Conditional] = []
        var statementsToHighlight: [Statement] = []
        
        for prop in propositions {
            if let c = prop.content as? Conditional {
                for pc in conditionals {
                    if Statement.hs(c, pc) != nil {
                        statementsToHighlight.append(c)
                        statementsToHighlight.append(pc)
                    }
                }
                conditionals.append(c)
            }
        }
        
        for prop in propositions {
            for sth in statementsToHighlight {
                if prop.content == sth {
                    prop.highlight = true
                }
            }
        }
    }
    
    func highlightModusPonensCandidates(selectedReferences: [Int]) -> Statement? {
        var conditionals: [Conditional] = []
        var statementsToHighlight: [Statement] = []
        
        var anyCompatibleStatement: Statement?
        var anyCompatibleConditional: Conditional?
        
        for r in selectedReferences {
            if let c = propositions[r].content as? Conditional {
                anyCompatibleConditional = c
            } else if let s = propositions[r].content as? Statement {
                anyCompatibleStatement = s
            }
        }
        
        for prop in propositions {
            for pc in conditionals {
                if Statement.mp(anyCompatibleConditional ?? pc, anyCompatibleStatement ?? prop.content) != nil {
                    statementsToHighlight.append(anyCompatibleStatement ?? prop.content)
                    statementsToHighlight.append(anyCompatibleConditional ?? pc)
                }
            }
            if prop.content.type == .conditional {
                conditionals.append(prop.content as! Conditional)
            }
        }
        
        for prop in propositions {
            for sth in statementsToHighlight {
                if prop.content == sth {
                    prop.highlight = true
                }
            }
        }
        
        if let uS = anyCompatibleStatement, let uC = anyCompatibleConditional {
            return Statement.mp(uC, uS)
        }
        
        return nil
    }
    
    func highlightModusTollensCandidates() {
        var conditionals: [Conditional] = []
        var statementsToHighlight: [Statement] = []
        
        for prop in propositions {
            for pc in conditionals {
                if Statement.mp(pc, prop.content) != nil {
                    statementsToHighlight.append(prop.content)
                    statementsToHighlight.append(pc)
                }
            }
            if prop.content.type == .conditional {
                conditionals.append(prop.content as! Conditional)
            }
        }
        
        for prop in propositions {
            for sth in statementsToHighlight {
                if prop.content == sth {
                    prop.highlight = true
                }
            }
        }
    }
    
    func highlightConjunctions() {
        for prop in propositions {
            if prop.content.type == .conjunction {
                prop.highlight = true
            }
        }
    }
    
    func highlightTautologyCandidates() {
        for prop in propositions {
            if let js = prop.content as? JunctureStatement {
                if Statement.taut(js) != nil {
                    prop.highlight = true
                }
            }
        }
    }
    
    func highlightConditionals() {
        for prop in propositions {
            if prop.content.type == .conditional {
                prop.highlight = true
            }
        }
    }
    
    func highlight(justification: JustificationType, selectedReferences: [Int], requestedBy: UUID) {
        clearHighlighting()
        var potentialReturn: Statement?
        switch justification {
        case .AD:
            highlightEverything()
        case .AS:
            highlightAssociationCandidates()
        case .CD:
            highlightConstructiveDilemmaCandidates()
        case .CM:
            highlightConjunctionsAndDisjunctions()
        case .CN:
            highlightEverything()
        case .DIST:
            highlightConjunctionsAndDisjunctions()
        case .DM:
            highlightDeMorgansRuleCandidates()
        case .DN:
            highlightEverything()
        case .DS:
            highlightDisjunctiveSyllogismCandidates()
        case .EXP:
            highlightExportationCandidates()
        case .HS:
            highlightHypotheticalSyllogismCandidates()
        case .IMP:
            highlightConjunctionsAndDisjunctions()
        case .MP:
            potentialReturn = highlightModusPonensCandidates(selectedReferences: selectedReferences)
        case .MT:
            highlightModusTollensCandidates()
        case .SM:
            highlightConjunctions()
        case .TAUT:
            highlightTautologyCandidates()
        case .TRAN:
            highlightConditionals()
        default:
            print("Justification highlights nothing")
        }
        
        if let r = potentialReturn {
            let p = proposition(for: requestedBy) ?? Proposition()
            let i = propositions.firstIndex(of: p)
            
            if let uI = i {
                propositions[uI].content = r
            }
        }
    }
}
