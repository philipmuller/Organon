//
//  Statement.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation

class Statement: Identifiable {
    var id = UUID()
    var type: StatementType = .simple
    var content: String?
    var symbol: String?
    var block: Bool {
        if type == .simple {
            return false
        } else {
            return true
        }
    }
    
    init() {
    }
    
    init(_ copy: Statement) {
        self.type = copy.type
        self.content = copy.content
    }
    
    init(text: String, symbol: String) {
        content = text
        self.symbol = symbol
    }
}

enum StatementType {
    case simple
    case complex
}
