//
//  File.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation

class Proposition: ObservableObject, Identifiable, Equatable {
    
    var id = UUID()
    @Published var type: PropositionType
    @Published var justification: Justification?
    var alias: String?
    @Published var highlight: Bool = false
    
    @Published var content: Statement
    @Published var invisible: Bool = false
    
    init() {
        type = .empty
        content = Statement()
        self.content.delete = statementRequestsDeletion(childID:)
        self.content.change = statementRequestsChange(childID:changeInto:)
        self.content.target = targetStatementAtCount(count:type:senderID:)
        self.content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    init(content: Statement) {
        self.content = content
        type = .premise
        self.content.delete = statementRequestsDeletion(childID:)
        self.content.change = statementRequestsChange(childID:changeInto:)
        self.content.target = targetStatementAtCount(count:type:senderID:)
        self.content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    init(content: Statement, type: PropositionType) {
        self.content = content
        self.type = type
        self.content.delete = statementRequestsDeletion(childID:)
        self.content.change = statementRequestsChange(childID:changeInto:)
        self.content.target = targetStatementAtCount(count:type:senderID:)
        self.content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    init(content: Statement, type: PropositionType, justification: Justification) {
        self.content = content
        self.type = type
        self.justification = justification
        self.content.delete = statementRequestsDeletion(childID:)
        self.content.change = statementRequestsChange(childID:changeInto:)
        self.content.target = targetStatementAtCount(count:type:senderID:)
        self.content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    init(content: Statement, position: Int) {
        self.content = content
        type = .premise
        self.content.delete = statementRequestsDeletion(childID:)
        self.content.change = statementRequestsChange(childID:changeInto:)
        self.content.target = targetStatementAtCount(count:type:senderID:)
        self.content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    init(content: Statement, type: PropositionType, position: Int) {
        self.content = content
        self.type = type
        self.content.delete = statementRequestsDeletion(childID:)
        self.content.change = statementRequestsChange(childID:changeInto:)
        self.content.target = targetStatementAtCount(count:type:senderID:)
        self.content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    init(content: Statement, type: PropositionType, justification: Justification, position: Int) {
        self.content = content
        self.type = type
        self.justification = justification
        self.content.delete = statementRequestsDeletion(childID:)
        self.content.change = statementRequestsChange(childID:changeInto:)
        self.content.target = targetStatementAtCount(count:type:senderID:)
        self.content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    init(content: Statement, alias: String) {
        self.content = content
        type = .premise
        self.alias = alias
        self.content.delete = statementRequestsDeletion(childID:)
        self.content.change = statementRequestsChange(childID:changeInto:)
        self.content.target = targetStatementAtCount(count:type:senderID:)
        self.content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    init(content: Statement, type: PropositionType, alias: String) {
        self.content = content
        self.type = type
        self.alias = alias
        self.content.delete = statementRequestsDeletion(childID:)
        self.content.change = statementRequestsChange(childID:changeInto:)
        self.content.target = targetStatementAtCount(count:type:senderID:)
        self.content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    init(content: Statement, type: PropositionType, justification: Justification, alias: String) {
        self.content = content
        self.type = type
        self.justification = justification
        self.alias = alias
        self.content.delete = statementRequestsDeletion(childID:)
        self.content.change = statementRequestsChange(childID:changeInto:)
        self.content.target = targetStatementAtCount(count:type:senderID:)
        self.content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    static func == (lhs: Proposition, rhs: Proposition) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
    func statementRequestsDeletion(childID: UUID) {
        content = Statement(content: "", formula: "")
        //content.id = childID
        content.delete = statementRequestsDeletion(childID:)
        content.change = statementRequestsChange(childID:changeInto:)
        content.target = targetStatementAtCount(count:type:senderID:)
        content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    func statementRequestsChange(childID: UUID, changeInto: Statement) {
        print("Proposition received change request from: \(childID), change into: \(changeInto.id)")
        changeInto.publisherID = content.publisherID
        if let pClosure = content.publishSimpleChange {
            changeInto.setPublishClosure(closure: pClosure)
        }
        content = changeInto
        //content.id = childID
        content.delete = statementRequestsDeletion(childID:)
        content.change = statementRequestsChange(childID:changeInto:)
        content.target = targetStatementAtCount(count:type:senderID:)
        content.changeTarget = addAtTargeted(connectionType:connectTo:)
    }
    
    func targetStatementAtCount(count: Int?, type: TargetingType, senderID: UUID) {
        print("Proposition here! Target counting has reached end station!")
    }
    
    func addAtTargeted(connectionType: StatementType, connectTo: Statement) {
        print("Proposition here. endline, I cannot be targeted!")
    }
    
}

enum PropositionType {
    case premise
    case conclusion
    case step
    case empty
}
