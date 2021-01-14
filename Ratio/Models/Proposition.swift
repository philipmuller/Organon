//
//  File.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation

class Proposition: Identifiable {
    var id = UUID()
    var type: PropositionType
    var justification: Justification?
    var number: Int
    var level = 0
    var alias: String?
    
    var content: Statement
    
    init(content: Statement) {
        self.content = content
        type = .premise
        number = 1
    }
    
    init(content: Statement, type: PropositionType) {
        self.content = content
        self.type = type
        number = 1
    }
    
    init(content: Statement, type: PropositionType, justification: Justification) {
        self.content = content
        self.type = type
        self.justification = justification
        number = 1
    }
    
    init(content: Statement, position: Int) {
        self.content = content
        type = .premise
        number = position
    }
    
    init(content: Statement, type: PropositionType, position: Int) {
        self.content = content
        self.type = type
        number = position
    }
    
    init(content: Statement, type: PropositionType, justification: Justification, position: Int) {
        self.content = content
        self.type = type
        self.justification = justification
        number = position
    }
    
    init(content: Statement, alias: String) {
        self.content = content
        type = .premise
        number = 1
        self.alias = alias
    }
    
    init(content: Statement, type: PropositionType, alias: String) {
        self.content = content
        self.type = type
        number = 1
        self.alias = alias
    }
    
    init(content: Statement, type: PropositionType, justification: Justification, alias: String) {
        self.content = content
        self.type = type
        self.justification = justification
        number = 1
        self.alias = alias
    }
    
    init(content: Statement, position: Int, alias: String) {
        self.content = content
        type = .premise
        number = position
        self.alias = alias
    }
    
    init(content: Statement, type: PropositionType, position: Int, alias: String) {
        self.content = content
        self.type = type
        number = position
        self.alias = alias
    }
    
    init(content: Statement, type: PropositionType, justification: Justification, position: Int, alias: String) {
        self.content = content
        self.type = type
        self.justification = justification
        number = position
        self.alias = alias
    }
    
}

enum PropositionType {
    case premise
    case conclusion
    case step
}
