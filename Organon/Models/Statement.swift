//
//  Statement.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation
import Combine

enum StatementType {
    case simple, conjunction, disjunction, conditional, negation
}

class Statement: ObservableObject, Identifiable, Equatable {
    static func == (lhs: Statement, rhs: Statement) -> Bool {
        if lhs.formula == rhs.formula {
            return true
        }
        
        return false
    }
    
    static func === (lhs: Statement, rhs: Statement) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }
    
    @Published var id = UUID()
    var type: StatementType = .simple
    @Published var content: String {
        didSet {
            if let uPublish = publishSimpleChange {
                if type == .simple {
                    uPublish(content, nil)
                }
            }
        }
    }
    @Published var formula: String
    var block: Bool {
        if type == .simple {
            return false
        } else {
            return true
        }
    }
    
    var structure: String {
        let charactersToReplace = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPRSTUVZXYZ")
        return formula.components(separatedBy: charactersToReplace).joined(separator: "*")
    }
    
    var delete: ((UUID) -> Void)?
    var change: ((UUID, Statement) -> Void)?
    var target: ((Int?, TargetingType, UUID) -> Void)?
    var changeTarget: ((StatementType, Statement) -> Void)?
    var publishSimpleChange: ((String, String?) -> Void)?
    var publisherID: UUID?
    
    @Published var targeted: Bool?
    @Published var targetingIntent: TargetingType?
    
    var targetingDirection: UUID?
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        self.content = ""
        self.formula = ""
        
        NotificationCenter.default
            .publisher(for: .simpleStatementChange)
            .compactMap{$0.object as? (String, String, UUID)}
            .sink() {
                [weak self] formula in
                self?.handleFormulaUpdate(updated: formula)
            }
            .store(in: &cancellables)
        
        if let uPublish = publishSimpleChange {
            if type == .simple {
                uPublish(content, nil)
            }
        }
            
    }
    
    init(content: String, formula: String) {
        self.content = content
        self.formula = formula
        
        NotificationCenter.default
            .publisher(for: .simpleStatementChange)
            .compactMap{$0.object as? (String, String, UUID)}
            .sink() {
                [weak self] formula in
                self?.handleFormulaUpdate(updated: formula)
            }
            .store(in: &cancellables)
        
        if let uPublish = publishSimpleChange {
            if type == .simple {
                uPublish(content, nil)
            }
        }
    }
    
    init(onDelete: ((UUID) -> Void)?, onChange: ((UUID, Statement) -> Void)?) {
        self.content = ""
        self.formula = ""
        self.delete = onDelete
        self.change = onChange
        
        NotificationCenter.default
            .publisher(for: .simpleStatementChange)
            .compactMap{$0.object as? (String, String, UUID)}
            .sink() {
                [weak self] formula in
                self?.handleFormulaUpdate(updated: formula)
            }
            .store(in: &cancellables)
        
        if let uPublish = publishSimpleChange {
            if type == .simple {
                uPublish(content, nil)
            }
        }
        
    }
    
    init(content: String, formula: String, onDelete: ((UUID) -> Void)?, onChange: ((UUID, Statement) -> Void)?) {
        self.content = content
        self.formula = formula
        self.delete = onDelete
        self.change = onChange
        
        NotificationCenter.default
            .publisher(for: .simpleStatementChange)
            .compactMap{$0.object as? (String, String, UUID)}
            .sink() {
                [weak self] formula in
                self?.handleFormulaUpdate(updated: formula)
            }
            .store(in: &cancellables)
        
        if let uPublish = publishSimpleChange {
            if type == .simple {
                uPublish(content, nil)
            }
        }

    }
    
    func handleFormulaUpdate(updated: (String, String, UUID)) {
        if let pID = publisherID {
            if updated.2 == pID {
                if type == .simple {
                    let newSymbol = updated.1
                    let newText = updated.0
                    
                    if newSymbol == formula {
                        if !matches(newText, content) {
                            content = newText
                        }
                    } else if matches(content, newText) {
                        formula = newSymbol
                    }
                }
            }
        }
    }
    
    private func matches(_ content: String, _ compareTo: String) -> Bool {
        if content != "" {
            let punctuation = CharacterSet.punctuationCharacters
            let whitespace = CharacterSet.whitespaces
            let unwanted = punctuation.union(whitespace)
            
            let simplifiedContentText = content.components(separatedBy: unwanted).joined(separator: " ")
            let comparisonText = compareTo.components(separatedBy: unwanted).joined(separator: " ")
            
            if simplifiedContentText.compare(comparisonText, options: .caseInsensitive) == .orderedSame {
                return true
            }
        }
        
        return false
    }
    
    func copy() -> Statement {
        return Statement(content: self.content, formula: self.formula, onDelete: self.delete, onChange: self.change)
    }
    
    func childRequestsDeletion(childID: UUID) {
        
    }
    
    func childRequestsChange(childID: UUID, changeInto: Statement) {
        print("Statement \(self.id) here! Child is requesting change! ChildID: \(childID), change into: \(changeInto)")
        
    }
    
    func setPublishClosure(closure: @escaping (String, String?) -> Void) {
        self.publishSimpleChange = closure
        
        if let uPublish = publishSimpleChange {
            if type == .simple {
                uPublish(content, nil)
            }
        }
    }
    
    func setPublisherID(id: UUID) {
        self.publisherID = id
    }
    
    func targetStatementAtCount(count: Int?, type: TargetingType, senderID: UUID) {
        print("TARGET STATEMENT AT COUNT \(count) TARGETING INTENT \(type) type \(self.type), targeting intent \(self.targetingIntent), ID: \(self.id), content: \(self.content)")
        if count == nil {
            targeted = nil
            targetingIntent = nil
            if let uTarget = self.target {
                uTarget(nil, type, self.id)
            }
        } else {
            if count! == 0 {
                targeted = true
                print("Currently targeting type: \(self.type), content: \(self.content)")
            } else if count! > 0 {
                targeted = nil
                print("type: \(self.type), content: \(self.content) NOT the targer. passing count \(count) - 1 to parent")
            } else {
                targeted = false
            }
            print("Changing tatgeting intent into: \(type)")
            self.targetingIntent = type
            if let uTarget = self.target {
                uTarget(count! - 1, type, self.id)
            }
        }
        
    }
    
    func propagateTargetingDownstream(value: Bool?, type: TargetingType) {
        self.targeted = value
        self.targetingIntent = .add
    }
    
    func findHomeFor(text: String, hotID: UUID) {
        if let uChange = change {
            let newSimple = Statement(content: self.content+text, formula: "")
            newSimple.id = hotID
            uChange(self.id, newSimple)
        }
    }
    
    func addAtTargeted(connectionType: StatementType, connectTo: Statement) {
        print("handling add at target request at statement type \(self.type), targeting intent \(self.targetingIntent), ID: \(self.id), content: \(self.content)")
        if let uTargeted = targeted {
            if uTargeted {
                print("I am targeted!")
                if let uTargetingIntent = targetingIntent {
                    if uTargetingIntent == .add {
                        print("Add intent")
                        if let uChange = change {
                            var newConfig: Statement = Statement()
                            //var oldStatement
                            
                            switch connectionType {
                            case .conditional:
                                newConfig = Conditional(self, connectTo)
                            case .conjunction:
                                newConfig = Conjunction(self, connectTo)
                            case .disjunction:
                                newConfig = Disjunction(self, connectTo)
                            case .negation:
                                newConfig = Negation(self)
                            default:
                                print("something went wrong. Targeting simple not possible")
                            }
                            print("Requesting change from parent. New config \(connectionType)")
                            print("connectTo \(connectTo.type), ID: \(connectTo.id), content: \(connectTo.content)")
                            if let pClosure = self.publishSimpleChange {
                                newConfig.setPublishClosure(closure: pClosure)
                            }
                            
                            if let pID = self.publisherID {
                                newConfig.publisherID = pID
                            }
                            uChange(self.id, newConfig)
                        }
                    } else {
                        print("Change/delete intent")
                        let currentType = self.type
                        if let uChange = change {
                            if currentType != connectionType {
                                var newConfig: Statement = self
                                
                                switch connectionType {
                                case .conditional:
                                    if let junction = self as? JunctureStatement {
                                        newConfig = Conditional(junction.firstChild, junction.secondChild)
                                    } else {
                                        if let negation = self as? Negation {
                                            newConfig = Conditional(negation.negatedStatement, Statement())
                                        }
                                    }
                                case .conjunction:
                                    if let junction = self as? JunctureStatement {
                                        newConfig = Conjunction(junction.firstChild, junction.secondChild)
                                    } else {
                                        if let negation = self as? Negation {
                                            newConfig = Conditional(negation.negatedStatement, Statement())
                                        }
                                    }
                                case .disjunction:
                                    if let junction = self as? JunctureStatement {
                                        newConfig = Disjunction(junction.firstChild, junction.secondChild)
                                    } else {
                                        if let negation = self as? Negation {
                                            newConfig = Conditional(negation.negatedStatement, Statement())
                                        }
                                    }
                                case .negation:
                                    print("Change from junctions to negation not yet supported")
                                default:
                                    print("We want to delete. Initiating deletion.")
                                    switch currentType {
                                    case .negation:
                                        let negation = self as! Negation
                                        newConfig = negation.negatedStatement
                                    default:
                                        
                                        if let junction = self as? JunctureStatement {
                                            let magicID = connectTo.id
                                            if let uOriginTargetingDirection = targetingDirection {
                                                if uOriginTargetingDirection == junction.firstChild.id {
                                                    junction.secondChild.findHomeFor(text: junction.firstChild.content, hotID: magicID)
                                                    newConfig = junction.secondChild
                                                } else {
                                                    junction.firstChild.findHomeFor(text: junction.secondChild.content, hotID: magicID)
                                                    newConfig = junction.firstChild
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                                print("Requesting change from parent. New config \(connectionType)")
                                print("connectTo \(connectTo.type), ID: \(connectTo.id), content: \(connectTo.content)")
                                if let pClosure = self.publishSimpleChange {
                                    newConfig.setPublishClosure(closure: pClosure)
                                }
                                
                                if let pID = self.publisherID {
                                    newConfig.publisherID = pID
                                }
                                uChange(self.id, newConfig)
                            }
                        }
                        
                    }
                    
                }
                
            } else {
                print("I am NOT targeted!")
                if let uChangeTarget = changeTarget {
                    uChangeTarget(connectionType, connectTo)
                }
            }
        } else {
            print("No targeting active.")
            if let uChangeTarget = changeTarget {
                uChangeTarget(connectionType, connectTo)
            }
        }
    }
    
    func childRequestsYourPresence() -> Statement {
        return self
    }
    
//    func childRequestsParentChange(childID: UUID, changeInto: Statement) {
//
//    }
    
    //Addition
    static func ad(_ s1: Statement, _ s2: Statement) -> Disjunction {
        return Disjunction(s1, s2)
    }
    
    //Association
    static func aS(_ cod: JunctureStatement) -> JunctureStatement? {
        if let c = cod as? Conjunction {
            if let cfc = c.firstChild as? Conjunction {
                let newFirstTerm = cfc.firstChild
                let newSecondTerm = Conjunction(cfc.secondChild, c.secondChild)
                return Conjunction(newFirstTerm, newSecondTerm)
            } else if let csc = c.secondChild as? Conjunction {
                let newFirstTerm = Conjunction(c.firstChild, csc.firstChild)
                let newSecondTerm = csc.secondChild
                return Conjunction(newFirstTerm, newSecondTerm)
            } else {
                return nil
            }
        } else if let d = cod as? Disjunction {
            if let dfc = d.firstChild as? Disjunction {
                let newFirstTerm = dfc.firstChild
                let newSecondTerm = Conjunction(dfc.secondChild, d.secondChild)
                return Conjunction(newFirstTerm, newSecondTerm)
            } else if let dsc = d.secondChild as? Disjunction {
                let newFirstTerm = Conjunction(d.firstChild, dsc.firstChild)
                let newSecondTerm = dsc.secondChild
                return Conjunction(newFirstTerm, newSecondTerm)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    //Constructive Dilemma
    static func cd(_ c: Conjunction, _ d: Disjunction) -> Disjunction? {
        if let fc = c.firstChild as? Conditional, let sc = c.secondChild as? Conditional {
            let fca = fc.firstChild
            let sca = sc.firstChild
            
            if (fca == d.firstChild && sca == d.secondChild) {
                return Disjunction(fc.secondChild, sc.secondChild)
            }
        }
        
        return nil
    }
    
    //Commutation
    static func cm(_ cod: JunctureStatement) -> JunctureStatement? {
        if let c = cod as? Conjunction {
            return Conjunction(c.secondChild, c.firstChild)
        } else if let d = cod as? Disjunction {
            return Disjunction(d.secondChild, d.firstChild)
        }
        
        return nil
    }
    
    //Conjunction
    static func cn(_ s1: Statement, _ s2: Statement) -> Conjunction {
        return Conjunction(s1, s2)
    }
    
    //Distribution
    static func dist1(_ cod: JunctureStatement) -> JunctureStatement? {
        if let c = cod as? Conjunction {
            if let fcd = c.firstChild as? Disjunction, let scd = c.secondChild as? Disjunction {
                if fcd.firstChild == scd.firstChild {
                    return Disjunction(fcd.firstChild, Conjunction(fcd.secondChild, scd.secondChild))
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else if let d = cod as? Disjunction {
            if let scc = d.secondChild as? Conjunction {
                return Conjunction(Disjunction(d.firstChild, scc.firstChild), Disjunction(d.firstChild, scc.secondChild))
            } else {
                return nil
            }
        }
        return nil
    }
    
    static func dist2(_ cod: JunctureStatement) -> JunctureStatement? {
        if let c = cod as? Conjunction {
            if let scd = c.secondChild as? Disjunction {
                return Disjunction(Conjunction(c.firstChild, scd.firstChild), Conjunction(c.firstChild, scd.secondChild))
            } else {
                return nil
            }
        } else if let d = cod as? Disjunction {
            if let fcc = d.firstChild as? Conjunction, let scc = d.secondChild as? Conjunction {
                if fcc.firstChild == scc.firstChild {
                    return Conjunction(fcc.firstChild, Disjunction(fcc.secondChild, scc.secondChild))
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        return nil
    }
    
    //De Morgan's rule
    static func dm(_ n: Negation) -> JunctureStatement? {
        if let nd = n.negatedStatement as? Disjunction {
            return Conjunction(opposite(nd.firstChild), opposite(nd.secondChild))
        } else if let nc = n.negatedStatement as? Conjunction {
            return Disjunction(opposite(nc.firstChild), opposite(nc.secondChild))
        }
        return nil
    }
    
    static func dm(_ cod: JunctureStatement) -> Negation? {
        if let d = cod as? Disjunction {
            return Negation(Conjunction(opposite(d.firstChild), d.secondChild))
        } else if let c = cod as? Conjunction {
            return Negation(Disjunction(opposite(c.firstChild), opposite(c.secondChild)))
        }
        return nil
    }
    
    static func opposite(_ input: Statement) -> Statement {
        return dn(Negation(input))
    }
    
    //Double negation
    static func dn(_ removeFrom: Negation) -> Statement {
        if let ns = removeFrom.negatedStatement as? Negation {
            if let nns = ns.negatedStatement as? Negation {
                return dn(nns)
            }
            return ns.negatedStatement
        }
        
        return removeFrom
    }
    
    static func dn(_ applyTo: Statement) -> Negation {
        return Negation(Negation(applyTo))
    }
    
    //Disjunctive syllogism
    static func ds(_ d: Disjunction, _ s: Statement) -> Statement? {
        let firstOpposite = areOpposite(d.firstChild, s)
        let secondOpposite = areOpposite(d.secondChild, s)
        
        if firstOpposite {
            return d.secondChild
        } else if secondOpposite {
            return d.firstChild
        }
        
        return nil
    }
    
    static func areOpposite(_ s1: Statement, _ s2: Statement) -> Bool {
        if s1 == opposite(s2) {
            return true
        } else {
            return false
        }
    }
    
    //Exportation
    static func exp(_ c: Conditional) -> Conditional? {
        if let antecedent = c.firstChild as? Conjunction {
            return Conditional(antecedent.firstChild, Conditional(antecedent.secondChild, c.secondChild))
        } else if let consequent = c.secondChild as? Conditional {
            return Conditional(Conjunction(c.firstChild, consequent.firstChild), consequent.secondChild)
        }
        return nil
    }
    
    //Hypothetical syllogism
    static func hs(_ c1: Conditional, _ c2: Conditional) -> Conditional? {
        if c1.secondChild == c2.firstChild {
            return Conditional(c1.firstChild, c2.secondChild)
        }
        return nil
    }
    
    //Material implication
    static func imp(_ d: Disjunction) -> Conditional {
        return Conditional(opposite(d.firstChild), d.secondChild)
    }

    static func imp(_ c: Conditional) -> Disjunction {
        Disjunction(opposite(c.firstChild), c.secondChild)
    }
    
    //Conditional proof
    static func cp(_ assumption: Statement, _ development: Statement) -> Conditional {
        return Conditional(assumption, development)
    }
    
    //Indirect proof
    static func ip(_ assumption: Statement) -> Statement {
        return opposite(assumption)
    }
    
    //Modus Ponens
    static func mp(_ c: Conditional, _ s: Statement) -> Statement? {
        if c.firstChild == s {
            return c.secondChild
        }
        return nil
    }
    
    //Modus Tollens
    static func mt(_ c: Conditional, _ s: Statement) -> Statement? {
        if c.secondChild == opposite(s) {
            return opposite(c.firstChild)
        }
        
        return nil
    }
    
    //Simplification
    static func sm(_ c: Conjunction) -> Statement {
        return c.firstChild
    }
    
    //Tautology version 1
    static func taut(_ reduce: JunctureStatement) -> Statement? {
        if reduce.type == .disjunction || reduce.type == .conjunction {
            if reduce.firstChild == reduce.secondChild {
                return reduce.firstChild
            }
        }
        return nil
    }
    
    //Tautology version 2
    static func taut(_ augment: Statement, cod: StatementType) -> JunctureStatement {
        if cod == .conjunction {
            return Conjunction(augment, augment)
        } else {
            return Disjunction(augment, augment)
        }
    }
    
    //Transposition
    static func tran(_ c: Conditional) -> Conditional {
        return Conditional(opposite(c.firstChild), opposite(c.secondChild))
    }
    
    
}


class JunctureStatement: Statement {
    @Published var firstChild: Statement
    @Published var secondChild: Statement
    
    override var content: String {
        get {
            let symbol: String
            
            switch type {
            case .conditional:
                symbol = " -> "
            case .conjunction:
                symbol = " · "
            case .disjunction:
                symbol = " v "
            default:
                symbol = ""
            }
            
            return (leftContent + symbol + rightContent)
        }
        
        set {
            print("Setting content for non-simple statement is illegal behaviour")
        }
    }
    
    override var formula: String {
        get {
            let symbol: String
            
            switch type {
            case .conditional:
                symbol = " -> "
            case .conjunction:
                symbol = " · "
            case .disjunction:
                symbol = " v "
            default:
                symbol = ""
            }
            
            return ("(" + leftSymbol + symbol + rightSymbol + ")")
        }
        
        set {
            print("Setting formula for non-simple statement is illegal behaviour")
        }
    }
    
    var leftContent: String {
        return firstChild.content
    }
    
    var rightContent: String {
        return secondChild.content
    }
    
    var leftSymbol: String {
        return firstChild.formula
    }
    
    var rightSymbol: String {
        return secondChild.formula
    }
    
    init(firstStatement: Statement, secondStatement: Statement, junction: StatementType) {
        firstChild = firstStatement
        secondChild = secondStatement
        
        super.init(content: "whatever", formula: "nnn")
        
        type = junction
        
        firstChild.delete = self.childRequestsDeletion(childID:)
        firstChild.change = self.childRequestsChange(childID:changeInto:)
        firstChild.target = self.targetStatementAtCount(count:type:senderID:)
        firstChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
        //firstChild.parent = self.childRequestsYourPresence
        
        secondChild.delete = self.childRequestsDeletion(childID:)
        secondChild.change = self.childRequestsChange(childID:changeInto:)
        secondChild.target = self.targetStatementAtCount(count:type:senderID:)
        secondChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
        //secondChild.parent = self.childr
        
    }
    
    init(firstStatement: Statement, secondStatement: Statement, junction: StatementType, onDelete: ((UUID) -> Void)?, onChange: ((UUID, Statement) -> Void)?) {
        firstChild = firstStatement
        secondChild = secondStatement
        
        super.init(content: "whatever", formula: "nnn", onDelete: onDelete, onChange: onChange)
        
        type = junction
        
        firstChild.delete = self.childRequestsDeletion(childID:)
        firstChild.change = self.childRequestsChange(childID:changeInto:)
        firstChild.target = self.targetStatementAtCount(count:type:senderID:)
        firstChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
        
        secondChild.delete = self.childRequestsDeletion(childID:)
        secondChild.change = self.childRequestsChange(childID:changeInto:)
        secondChild.target = self.targetStatementAtCount(count:type:senderID:)
        secondChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
        
    }
    
    override func setPublishClosure(closure: @escaping (String, String?) -> Void) {
        self.publishSimpleChange = closure
        self.firstChild.setPublishClosure(closure: closure)
        self.secondChild.setPublishClosure(closure: closure)
    }
    
    override func setPublisherID(id: UUID) {
        super.setPublisherID(id: id)
        self.firstChild.setPublisherID(id: id)
        self.secondChild.setPublisherID(id: id)
    }
    
    override func copy() -> JunctureStatement {
        return JunctureStatement(firstStatement: self.firstChild.copy(), secondStatement: self.secondChild.copy(), junction: self.type)
    }
    
    override func childRequestsDeletion(childID: UUID) {
        if let uChange = change {
            uChange(id, (childID == firstChild.id) ? secondChild : firstChild)
        }
        
    }
    
    override func findHomeFor(text: String, hotID: UUID) {
        secondChild.findHomeFor(text: text, hotID: hotID)
    }
    
    override func propagateTargetingDownstream(value: Bool?, type: TargetingType) {
        self.targeted = value
        self.targetingIntent = .add
        firstChild.propagateTargetingDownstream(value: value, type: .add)
        secondChild.propagateTargetingDownstream(value: value, type: .add)
    }
    
    override func targetStatementAtCount(count: Int?, type: TargetingType, senderID: UUID) {
        super.targetStatementAtCount(count: count, type: type, senderID: senderID)
        targetingDirection = senderID
        if senderID == firstChild.id {
            if count == nil {
                secondChild.propagateTargetingDownstream(value: nil, type: type)
            } else if count! >= 0 {
                secondChild.propagateTargetingDownstream(value: nil, type: type)
            } else {
                secondChild.propagateTargetingDownstream(value: false, type: type)
            }
        } else {
            if count == nil {
                firstChild.propagateTargetingDownstream(value: nil, type: type)
            } else if count! >= 0 {
                firstChild.propagateTargetingDownstream(value: nil, type: type)
            } else {
                firstChild.propagateTargetingDownstream(value: false, type: type)
            }
        }
    }
    
    override func childRequestsChange(childID: UUID, changeInto: Statement) {
        print("Statement received change request from: \(childID), change into: \(changeInto.id)")
        if childID == firstChild.id {
            
            firstChild = changeInto
            //firstChild.id = oldID
            firstChild.delete = self.childRequestsDeletion(childID:)
            firstChild.change = self.childRequestsChange(childID:changeInto:)
            firstChild.target = self.targetStatementAtCount(count:type:senderID:)
            firstChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
            
            if let uPublishSimpleChange = self.publishSimpleChange {
                firstChild.setPublishClosure(closure: uPublishSimpleChange)
            }
            
        } else if childID == secondChild.id {
            //secondChild = Statement()
            secondChild = changeInto
            secondChild.delete = self.childRequestsDeletion(childID:)
            secondChild.change = self.childRequestsChange(childID:changeInto:)
            secondChild.target = self.targetStatementAtCount(count:type:senderID:)
            secondChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
            
            if let uPublishSimpleChange = self.publishSimpleChange {
                secondChild.setPublishClosure(closure: uPublishSimpleChange)
            }
            
        }
    }
    
    //wrapper deletion needs to be handled
}

class Negation: Statement {
    @Published var negatedStatement: Statement
    
    var negatedStatementContent: String {
        return negatedStatement.content
    }
    
    var negatedStatementFormula: String {
        return negatedStatement.formula
    }
    
    override var content: String {
        get {
            return ("~ " + negatedStatement.content)
        }
        
        set {
            print("Setting content for non-simple statement is illegal behaviour")
        }
    }
    
    override var formula: String {
        get {
            return ("(" + "~" + negatedStatement.formula + ")")
        }
        
        set {
            print("Setting formula for non-simple statement is illegal behaviour")
        }
    }
    
    init(_ statementToNegate: Statement) {
        negatedStatement = statementToNegate
        super.init(content: "whatever", formula: "nnn")
        
        type = .negation
        
        negatedStatement.delete = self.childRequestsDeletion(childID:)
        negatedStatement.change = self.childRequestsChange(childID:changeInto:)
        negatedStatement.target = self.targetStatementAtCount(count:type:senderID:)
        negatedStatement.changeTarget = self.addAtTargeted(connectionType:connectTo:)
        
        if let uPublishSimpleChange = self.publishSimpleChange {
            negatedStatement.setPublishClosure(closure: uPublishSimpleChange)
        }
    }
    
    override func copy() -> Negation {
        return Negation(self.negatedStatement.copy())
    }
    
    override func childRequestsDeletion(childID: UUID) {
        if let uDelete = delete {
            uDelete(id)
        }
        
    }
    
    override func findHomeFor(text: String, hotID: UUID) {
        negatedStatement.findHomeFor(text: text, hotID: hotID)
    }
    
    override func propagateTargetingDownstream(value: Bool?, type: TargetingType) {
        self.targeted = value
        self.targetingIntent = .add
        negatedStatement.propagateTargetingDownstream(value: value, type: .add)
    }
    
    override func childRequestsChange(childID: UUID, changeInto: Statement) {
        negatedStatement = changeInto
        //negatedStatement.id = oldID
        negatedStatement.delete = self.childRequestsDeletion(childID:)
        negatedStatement.change = self.childRequestsChange(childID:changeInto:)
        negatedStatement.target = self.targetStatementAtCount(count:type:senderID:)
        negatedStatement.changeTarget = self.addAtTargeted(connectionType:connectTo:)
        
        if let uPublishSimpleChange = self.publishSimpleChange {
            negatedStatement.setPublishClosure(closure: uPublishSimpleChange)
        }
    }
    
    override func setPublishClosure(closure: @escaping (String, String?) -> Void) {
        self.publishSimpleChange = closure
        self.negatedStatement.setPublishClosure(closure: closure)
    }
    
    override func setPublisherID(id: UUID) {
        super.setPublisherID(id: id)
        self.negatedStatement.setPublisherID(id: id)
    }
}

class Conjunction: JunctureStatement {
    init(_ first: Statement, _ second: Statement) {
        super.init(firstStatement: first, secondStatement: second, junction: .conjunction)
    }
    
    override func copy() -> Conjunction {
        return Conjunction(self.firstChild.copy(), self.secondChild.copy())
    }
}

class Disjunction: JunctureStatement {
    init(_ first: Statement, _ second: Statement) {
        super.init(firstStatement: first, secondStatement: second, junction: .disjunction)
    }
    
    override func copy() -> Disjunction {
        return Disjunction(self.firstChild.copy(), self.secondChild.copy())
    }
}

class Conditional: JunctureStatement {
    init(_ antecedent: Statement, _ consequent: Statement) {
        super.init(firstStatement: antecedent, secondStatement: consequent, junction: .conditional)
    }
    
    override func copy() -> Conditional {
        return Conditional(self.firstChild.copy(), self.secondChild.copy())
    }
}

enum TargetingType {
    case add, deleteOchange
}
