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
        //check dependencies of thing you wish to delete
        if let dependencies = propositionsReliantOn(proposition: proposition) {
            for dependence in dependencies {
                let dependentProposition = self.proposition(for: dependence)
                let i = propositions.firstIndex(of: dependentProposition!)!
                propositions[i].justification = nil
                propositions[i].type = .premise
            }
        }
        
        
        propositions.remove(at: propositions.firstIndex(of: proposition)!)
        rearrange()
        
    }
    
    mutating func add() {
        let newProposition = Proposition(content: Statement(content: "test", formula: "A"))
        propositions.append(newProposition)
    }
    
    mutating func add(proposition: Proposition) {
        propositions.append(proposition)
    }
    
    func index(for proposition: Proposition) -> Int {
        return propositions.firstIndex(of: proposition)!
    }
    
    mutating func rearrange() {
        propositions.sort(by: {
            
            switch ($0.type, $1.type) {
            case (.premise, .step):
                return true
            case (.premise, .conclusion):
                return true
            case (.premise, .premise):
                return false
            case (.step, .step):
                return false
            case (.step, .conclusion):
                return true
            case (.step, .premise):
                return false
            case (.conclusion, .step):
                return false
            case (.conclusion, .conclusion):
                return false
            case (.conclusion, .premise):
                return false
            default:
                return false
            }
            
            
            
        })
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
    
    func propositionsReliantOn(proposition: Proposition) -> [UUID]? {
        if let index = propositions.firstIndex(of: proposition) {
            return dependencyMap[index]
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
    
    var dependencyMap: [[UUID]] {
        var map: [[UUID]] = []
        for proposition in propositions {
            var dependenciesOfCurrentProposition: [UUID] = []
            for possibleDependency in propositions {
                if let ids = possibleDependency.justification?.references {
                    for id in ids {
                        if id == proposition.id {
                            dependenciesOfCurrentProposition.append(possibleDependency.id)
                        }
                    }
                }
            }
            map.append(dependenciesOfCurrentProposition)
            dependenciesOfCurrentProposition = []
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
