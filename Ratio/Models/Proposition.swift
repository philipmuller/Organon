//
//  File.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation

class Proposition: Identifiable, Deletable, Equatable {
    
    var id = UUID()
    var type: PropositionType
    var justification: Justification?
    var level = 0
    var alias: String?
    weak var manager: DeletableDelegate?
    
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
    
    func delete() {
        manager?.requestDeletion(self)
    }
    
    static func == (lhs: Proposition, rhs: Proposition) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
}

protocol Deletable {
    var id: UUID { get }
    func delete()
}

enum PropositionType {
    case premise
    case conclusion
    case step
}
