//
//  ComplexStatement.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation

class ComplexStatement: Statement {
    let csType: ComplexStatementType
    let childStatements: [Statement]
    
    var leftContent: String {
        let leftStatement = childStatements.first
        
        if let leftCStatement = leftStatement as? ComplexStatement {
            return leftCStatement.complexContent
        } else {
            return leftStatement!.content!
        }
    }
    
    var rightContent: String {
        let rightStatement = childStatements.last
        
        if let rightCStatement = rightStatement as? ComplexStatement {
            return rightCStatement.complexContent
        } else {
            return rightStatement!.content!
        }
    }
    
    var complexContent: String {
        var op = ""
        
        switch csType {
        case .and:
            op = " ·  "
        case .ifthen:
            op = " > "
        case .or:
            op = " v "
        default:
            op = ""
        }
        
        if csType == .negation {
            return "~ " + rightContent
        } else {
            return leftContent + op + rightContent
        }
        
        
    }
    
    init(type: ComplexStatementType, blocks: [Statement]) {
        self.csType = type
        self.childStatements = blocks
        super.init()
        self.type = .complex
    }
    
    init(_ copy: ComplexStatement) {
        self.csType = copy.csType
        self.childStatements = copy.childStatements
        super.init()
        self.type = copy.type
        self.content = copy.content
        self.hasNeighbourBlocks = copy.hasNeighbourBlocks
    }
}

enum ComplexStatementType {
    case and
    case or
    case ifthen
    case negation
}
