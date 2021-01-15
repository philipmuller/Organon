//
//  Argument.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation

class Argument: ObservableObject {
    var title: String
    @Published var propositions: [Proposition]
    var numberOfSteps: Int {
        propositions.count
    }
    
    init(title: String, propositions: [Proposition]) {
        
        var indent = 0
        var count = 1
        
        for proposition in propositions {
            if let t = proposition.justification?.type {
                if t == .ACP || t == .AIP {
                    indent += 1
                }
                
                if t == .IP || t == .CP {
                    indent -= 1
                }
            }

            proposition.level = indent
            proposition.number = count
            
            count += 1
        }
        
        self.title = title
        self.propositions = propositions
    }
}
