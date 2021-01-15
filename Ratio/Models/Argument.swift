//
//  Argument.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation
import Combine

class Argument: ObservableObject, DeletableDelegate {
    var title: String
    @Published var propositions: [Proposition] {
        didSet {
            
            var deletedProposition: Proposition? = oldValue.first
            
            for oProposition in oldValue {
                var matches = 0
                for nProposition in propositions {
                    if oProposition == nProposition {
                        matches += 1
                    }
                }
                if matches == 0 {
                    deletedProposition = oProposition
                }
            }
        }
    }
    var numberOfSteps: Int {
        propositions.count
    }
    
    init(title: String, propositions: [Proposition]) {
        
        var indent = 0
        
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
        }
        
        self.title = title
        self.propositions = propositions
        
        for proposition in self.propositions {
            proposition.manager = self
        }
    }
    
    func removeProposition(id: UUID) -> Void {
        
        var deletedNumber: Int = propositions.count
        
        propositions.removeAll() { proposition in
            if proposition.id == id {
                return true
            }
            
            return false
        }
    }
    
    func requestDeletion(_ item: Deletable) {
        print("deletion requested. item: \(item)")
        removeProposition(id: item.id)
    }
    
    
}

protocol DeletableDelegate: AnyObject {
    func requestDeletion(_ item: Deletable)
}
