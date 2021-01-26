//
//  Statement.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation

enum StatementType {
    case simple, conjunction, disjunction, conditional, negation
}

class Statement: ObservableObject, Identifiable, Equatable {
    static func == (lhs: Statement, rhs: Statement) -> Bool {
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
    @Published var content: String
    var formula: String
    var block: Bool {
        if type == .simple {
            return false
        } else {
            return true
        }
    }
    
    var delete: ((UUID) -> Void)?
    var change: ((UUID, Statement) -> Void)?
    var target: ((Int?) -> Void)?
    var changeTarget: ((StatementType, Statement) -> Void)?
    var parent: (() -> Statement)?
    
    @Published var targeted: Bool = false
    
    init() {
        self.content = ""
        self.formula = ""
    }
    
    init(content: String, formula: String) {
        self.content = content
        self.formula = formula
    }
    
    init(onDelete: ((UUID) -> Void)?, onChange: ((UUID, Statement) -> Void)?) {
        self.content = ""
        self.formula = ""
        self.delete = onDelete
        self.change = onChange
    }
    
    init(content: String, formula: String, onDelete: ((UUID) -> Void)?, onChange: ((UUID, Statement) -> Void)?) {
        self.content = content
        self.formula = formula
        self.delete = onDelete
        self.change = onChange
    }
    
    func copy() -> Statement {
        return Statement(content: self.content, formula: self.formula, onDelete: self.delete, onChange: self.change)
    }
    
    func childRequestsDeletion(childID: UUID) {
        
    }
    
    func childRequestsChange(childID: UUID, changeInto: Statement) {
        print("Statement \(self.id) here! Child is requesting change! ChildID: \(childID), change into: \(changeInto)")
        
    }
    
    func targetStatementAtCount(count: Int?) {
        if count == nil {
           targeted = false
            if let uTarget = self.target {
                uTarget(nil)
            }
        } else {
            if count == 0 {
                targeted = true
                print("Currently targeting type: \(self.type), content: \(self.content)")
                if let uTarget = self.target {
                    uTarget(nil)
                }
            } else {
                targeted = false
                if let uTarget = self.target {
                    print("type: \(self.type), content: \(self.content) NOT the targer. passing count \(count) - 1 to parent")
                    uTarget(count! - 1)
                }
            }
        }
        
    }
    
    func addAtTargeted(connectionType: StatementType, connectTo: Statement) {
        print("handling add at target request at statement type \(self.type), ID: \(self.id), content: \(self.content)")
        if targeted {
            print("I am targeted!")
            if let uChange = change {
                var newConfig: Statement = Statement()
                //var oldStatement
                
                switch connectionType {
                case .conditional:
                    newConfig = Conditional(self.copy(), connectTo)
                case .conjunction:
                    newConfig = Conjunction(self.copy(), connectTo)
                case .disjunction:
                    newConfig = Disjunction(self.copy(), connectTo)
                case .negation:
                    newConfig = Negation(self.copy())
                default:
                    print("something went wrong. Targeting simple not possible")
                }
                print("Requesting change from parent. New config \(connectionType)")
                print("connectTo \(connectTo.type), ID: \(connectTo.id), content: \(connectTo.content)")
                uChange(self.id, newConfig)
            }
        } else {
            print("I am NOT targeted!")
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
    static func ad(_ s1: Statement, _ s2: Statement) -> Disjunction? {
        return nil
    }
    
    //Association
    static func aS(_ cod: JunctureStatement) -> JunctureStatement? {
        return nil
    }
    
    //Constructive Dilemma
    static func cd(_ c: Conjuntion, _ s: Disjunction) -> Disjunction? {
        return nil
    }
    
    //Commutation
    static func cm(_ cod: JunctureStatement) -> JunctureStatement? {
        return nil
    }
    
    //Conjunction
    static func cn(_ s1: Statement, _ s2: Statement) -> Conjunction? {
        return nil
    }
    
    //Distribution
    static func cn(_ cod: JunctureStatement) -> JunctureStatement? {
        return nil
    }
    
    //De Morgan's rule version 1
    static func dm1(_ n: Negation) -> Conjunction? {
        return nil
    }
    
    //De Morgan's rule version 2
    static func dm2(_ n: Conjunction) -> Negation? {
        return nil
    }
    
    //Double negation version 1
    static func dn1(_ n: Negation) -> Statement? {
        return nil
    }
    
    //Double negation version 2
    static func dn1(_ s: Statement) -> Negation? {
        return nil
    }
    
    //Disjunctive syllogism
    static func ds(_ d: Disjunction, _ s: Statement) -> Statement? {
        return nil
    }
    
    //Exportation
    static func exp(_ c: Conditional) -> Conditional? {
        return nil
    }
    
    //Hypothetical syllogism
    static func hs(_ c1: Conditional, _ c2: Conditional) -> Conditional? {
        return nil
    }
    
    //Material implication version 1
    static func imp1(_ d: Disjunction) -> Conditional? {
        return nil
    }
    
    //Material implication version 2
    static func imp2(_ d: Conditional) -> Disjunction? {
        return nil
    }
    
    //Conditional proof
    static func cp(_ s1: Statement, _ s2: Statement) -> Conditional? {
        return nil
    }
    
    //Indirect proof
    static func ip(_ s: Statement) -> Negation? {
        return nil
    }
    
    //Modus Ponens
    static func mp(_ c: Conditional, _ s: Statement) -> Statement? {
        return nil
    }
    
    //Modus Tollens
    static func mt(_ c: Conditional, _ s: Statement) -> Statement? {
        return nil
    }
    
    //Simplification
    static func sm(_ c: Conjunction) -> Statement? {
        return nil
    }
    
    //Tautology version 1
    static func taut1(_ cod: JunctureStatement) -> Statement? {
        return nil
    }
    
    //Tautology version 2
    static func taut2(_ cod: Statement) -> JunctureStatement? {
        return nil
    }
    
    //Transposition
    static func tran(_ c: Conditional) -> Conditional? {
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}


class JunctureStatement: Statement {
    @Published var firstChild: Statement {
        didSet {
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
            
            self.content = firstChild.content + symbol + secondChild.content
            self.formula = "(" + firstChild.formula + symbol + secondChild.formula + ")"
        }
    }
    @Published var secondChild: Statement {
        didSet {
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
            
            self.content = firstChild.content + symbol + secondChild.content
            self.formula = "(" + firstChild.formula + symbol + secondChild.formula + ")"
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
        
        let symbol: String
        
        switch junction {
        case .conditional:
            symbol = " -> "
        case .conjunction:
            symbol = " · "
        case .disjunction:
            symbol = " v "
        default:
            symbol = ""
        }
        
        let preppedContent = firstStatement.content + symbol + secondStatement.content
        let preppedFormula = "(" + firstStatement.formula + symbol + secondStatement.formula + ")"
        
        super.init(content: preppedContent, formula: preppedFormula)
        
        type = junction
        
        firstChild.delete = self.childRequestsDeletion(childID:)
        firstChild.change = self.childRequestsChange(childID:changeInto:)
        firstChild.target = self.targetStatementAtCount(count:)
        firstChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
        //firstChild.parent = self.childRequestsYourPresence
        
        secondChild.delete = self.childRequestsDeletion(childID:)
        secondChild.change = self.childRequestsChange(childID:changeInto:)
        secondChild.target = self.targetStatementAtCount(count:)
        secondChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
        //secondChild.parent = self.childr
        
    }
    
    init(firstStatement: Statement, secondStatement: Statement, junction: StatementType, onDelete: ((UUID) -> Void)?, onChange: ((UUID, Statement) -> Void)?) {
        firstChild = firstStatement
        secondChild = secondStatement
        
        let symbol: String
        
        switch junction {
        case .conditional:
            symbol = " -> "
        case .conjunction:
            symbol = " · "
        case .disjunction:
            symbol = " v "
        default:
            symbol = ""
        }
        
        let preppedContent = firstStatement.content + symbol + secondStatement.content
        let preppedFormula = "(" + firstStatement.formula + symbol + secondStatement.formula + ")"
        
        super.init(content: preppedContent, formula: preppedFormula, onDelete: onDelete, onChange: onChange)
        
        type = junction
        
        firstChild.delete = self.childRequestsDeletion(childID:)
        firstChild.change = self.childRequestsChange(childID:changeInto:)
        firstChild.target = self.targetStatementAtCount(count:)
        firstChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
        
        secondChild.delete = self.childRequestsDeletion(childID:)
        secondChild.change = self.childRequestsChange(childID:changeInto:)
        secondChild.target = self.targetStatementAtCount(count:)
        secondChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
        
    }
    
    override func copy() -> JunctureStatement {
        return JunctureStatement(firstStatement: self.firstChild.copy(), secondStatement: self.secondChild.copy(), junction: self.type)
    }
    
    override func childRequestsDeletion(childID: UUID) {
        if let uChange = change {
            uChange(id, (childID == firstChild.id) ? secondChild : firstChild)
        }
        
    }
    
    override func childRequestsChange(childID: UUID, changeInto: Statement) {
        print("Statement received change request from: \(childID), change into: \(changeInto.id)")
        if childID == firstChild.id {
            
            firstChild = changeInto
            //firstChild.id = oldID
            firstChild.delete = self.childRequestsDeletion(childID:)
            firstChild.change = self.childRequestsChange(childID:changeInto:)
            firstChild.target = self.targetStatementAtCount(count:)
            firstChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
            
        } else if childID == secondChild.id {
            //secondChild = Statement()
            secondChild = changeInto
            secondChild.delete = self.childRequestsDeletion(childID:)
            secondChild.change = self.childRequestsChange(childID:changeInto:)
            secondChild.target = self.targetStatementAtCount(count:)
            secondChild.changeTarget = self.addAtTargeted(connectionType:connectTo:)
            
        }
    }
    
    //wrapper deletion needs to be handled
}

class Negation: Statement {
    @Published var negatedStatement: Statement {
        didSet {
            self.content = "~ " + negatedStatement.content
            self.formula = "(" + "~" + negatedStatement.formula + ")"
        }
    }
    
    var negatedStatementContent: String {
        return negatedStatement.content
    }
    
    var negatedStatementFormula: String {
        return negatedStatement.formula
    }
    
    init(_ statementToNegate: Statement) {
        negatedStatement = statementToNegate
        
        let preppedContent = "~ " + statementToNegate.content
        let preppedFormula = "(" + "~" + statementToNegate.formula + ")"
        
        super.init(content: preppedContent, formula: preppedFormula)
        
        type = .negation
        
        negatedStatement.delete = self.childRequestsDeletion(childID:)
        negatedStatement.change = self.childRequestsChange(childID:changeInto:)
        negatedStatement.target = self.targetStatementAtCount(count:)
        negatedStatement.changeTarget = self.addAtTargeted(connectionType:connectTo:)
    }
    
    override func copy() -> Negation {
        return Negation(self.negatedStatement.copy())
    }
    
    override func childRequestsDeletion(childID: UUID) {
        if let uDelete = delete {
            uDelete(id)
        }
        
    }
    
    override func childRequestsChange(childID: UUID, changeInto: Statement) {
        negatedStatement = changeInto
        //negatedStatement.id = oldID
        negatedStatement.delete = self.childRequestsDeletion(childID:)
        negatedStatement.change = self.childRequestsChange(childID:changeInto:)
        negatedStatement.target = self.targetStatementAtCount(count:)
        negatedStatement.changeTarget = self.addAtTargeted(connectionType:connectTo:)
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
