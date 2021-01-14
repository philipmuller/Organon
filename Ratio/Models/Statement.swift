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

class Statement: Identifiable {
    var id = UUID()
    var type: StatementType = .simple
    var content: String
    var formula: String
    var block: Bool {
        if type == .simple {
            return false
        } else {
            return true
        }
    }
    
    init(content: String, formula: String) {
        self.content = content
        self.formula = formula
    }
    
}


class JunctureStatement: Statement {
    var firstChild: Statement
    var secondChild: Statement
    
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
        
    }
}

class Negation: Statement {
    var negatedStatement: Statement
    
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
    }
}

class Conjunction: JunctureStatement {
    init(_ first: Statement, _ second: Statement) {
        super.init(firstStatement: first, secondStatement: second, junction: .conjunction)
    }
}

class Disjunction: JunctureStatement {
    init(_ first: Statement, _ second: Statement) {
        super.init(firstStatement: first, secondStatement: second, junction: .disjunction)
    }
}

class Conditional: JunctureStatement {
    init(_ antecedent: Statement, _ consequent: Statement) {
        super.init(firstStatement: antecedent, secondStatement: consequent, junction: .conditional)
    }
}
