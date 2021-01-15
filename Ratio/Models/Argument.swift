//
//  Argument.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation
import Combine

class Argument: ObservableObject {
    var title: String
    @Published var formalData: FormalData
    
    init(title: String, propositions: [Proposition]) {
        self.title = title
        self.formalData = FormalData(propositions: propositions)
    }
    
    
}

struct FormalData {
    var propositions: [Proposition]
    
    mutating func remove(proposition: Proposition) {
        propositions.remove(at: propositions.firstIndex(of: proposition)!)
    }
    
    func position(of input: Proposition) -> Int {
        return propositions.firstIndex(of: input)! + 1
    }
    
    var numberOfSteps: Int {
        propositions.count
    }
    
    func proposition(for id: UUID) -> Proposition? {
        for proposition in propositions {
            if proposition.id == id {
                return proposition
            }
        }
        
        return nil
    }
    
    func references(of input: Proposition) -> [Int]? {
        if let idReferences = input.justification?.references {
            var numericalReferences: [Int] = []
            for id in idReferences {
                if let desiredProposition = proposition(for: id) {
                    numericalReferences.append(position(of: desiredProposition))
                }
            }
            
            return numericalReferences
        }
        
        return nil
    }
    
    var numberOfLevels: Int {
        var levelCount = 0
        for proposition in propositions {
            if let t = proposition.justification?.type {
                if t == .ACP || t == .AIP {
                    levelCount += 1
                }
//                if t == .IP || t == .CP {
//                    indent -= 1
//                }
            }
        }
        
        return levelCount
    }
    
    var levelMap: [Int] {
        var map: [Int] = []
        var currentLevel = 0
        for proposition in propositions {
            if let t = proposition.justification?.type {
                if t == .ACP || t == .AIP {
                    currentLevel += 1
                }
                
                if t == .IP || t == .CP {
                    currentLevel -= 1
                }
            }
            
            map.append(currentLevel)
        }
        
        return map
    }
    
    func boundsFor(level: Int) -> (Int, Int?)? {
        if level > numberOfLevels {
            return nil
        } else if level == 0 {
            return numberOfSteps == 0 ? nil : (1, numberOfSteps)
        } else {
            var lowerFound = false
            var upperFound = false
            var isOpen = false
            
            var count = 0
            
            var currentLevel = 0
            var lowerBound = 1
            var upperBound = numberOfSteps
            for proposition in propositions {
                count += 1
                
                if let t = proposition.justification?.type {
                    if t == .ACP || t == .AIP {
                        currentLevel += 1
                    }
                    
                    if t == .IP || t == .CP {
                        currentLevel -= 1
                    }
                }
                
                if lowerFound == false {
                    lowerBound += 1
                }
                
                if currentLevel == level {
                    lowerFound = true
                }
                
                if lowerFound == true && currentLevel < level {
                    upperFound = true
                }
                
                if upperFound == false {
                    upperBound += 1
                }
                
                if count == numberOfSteps && level == currentLevel {
                    isOpen = true
                }
            }
            
            return (lowerBound, isOpen ? nil : upperBound)
        }
    }
    
    func level(of input: Proposition) -> Int {
        let propositionIndex = propositions.firstIndex(of: input)!
        
        return levelMap[propositionIndex]
    }
    
}
