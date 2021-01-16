//
//  File.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation
import MobileCoreServices
import UIKit

class Proposition: NSObject, Codable, Identifiable, NSItemProviderWriting, NSItemProviderReading {
    
    static var readableTypeIdentifiersForItemProvider: [String] = [kUTTypeData as String]
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let decoder = JSONDecoder()
        
        do {
            let myJSON = try decoder.decode(self, from: data)
            return myJSON
        } catch {
            fatalError("Err")
        }
    }
    
    
    
    static var writableTypeIdentifiersForItemProvider: [String] = [kUTTypeData as String]
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            let json = String(data: data, encoding: String.Encoding.utf8)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {

            completionHandler(nil, error)
        }

        return progress
    }
    
    
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

enum PropositionType: String, Codable {
    case premise
    case conclusion
    case step
    case opaque
}
