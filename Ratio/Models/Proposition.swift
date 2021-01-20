//
//  File.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation

struct Proposition: Identifiable, Equatable, Hashable {
    
    var id = UUID()
    var type: PropositionType
    var justification: Justification?
    var alias: String?
    
    var content: Statement
    
    init(content: Statement) {
        self.content = content
        type = .premise
    }
    
    init(content: Statement, type: PropositionType) {
        self.content = content
        self.type = type
    }
    
    init(content: Statement, type: PropositionType, justification: Justification) {
        self.content = content
        self.type = type
        self.justification = justification
    }
    
    init(content: Statement, position: Int) {
        self.content = content
        type = .premise
    }
    
    init(content: Statement, type: PropositionType, position: Int) {
        self.content = content
        self.type = type
    }
    
    init(content: Statement, type: PropositionType, justification: Justification, position: Int) {
        self.content = content
        self.type = type
        self.justification = justification
    }
    
    init(content: Statement, alias: String) {
        self.content = content
        type = .premise
        self.alias = alias
    }
    
    init(content: Statement, type: PropositionType, alias: String) {
        self.content = content
        self.type = type
        self.alias = alias
    }
    
    init(content: Statement, type: PropositionType, justification: Justification, alias: String) {
        self.content = content
        self.type = type
        self.justification = justification
        self.alias = alias
    }
    
    static func == (lhs: Proposition, rhs: Proposition) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
}

enum PropositionType {
    case premise
    case conclusion
    case step
}
