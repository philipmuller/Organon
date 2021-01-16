//
//  Argument.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation
import SwiftUI

class Argument: ObservableObject {
    var title: String
    @Published var formalData: FormalData
    
    init(title: String, propositions: [Proposition]) {
        self.title = title
        self.formalData = FormalData(propositions: propositions)
    }
    
    
}

struct FormalData: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        let gridPosition = getGridPosition(location: info.location)
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        let pr = proposition(for: getHoverID(location: info.location))
        let index = propositions.firstIndex(of: pr!)!
        print("preciseLocation: \(info.location.y), propositionIndex: \(index)")
                    
        return nil
    }
    
    func map(minRange:CGFloat, maxRange:CGFloat, minDomain:CGFloat, maxDomain:CGFloat, value:CGFloat) -> CGFloat {
        return minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
    }
    
    func getHoverID(location: CGPoint) -> UUID {
        let locationY = location.y
        
        var locations: [CGFloat] = []
        
        for proposition in propositions {
            locations.append(boundsMap[proposition.id] ?? 0.0)
        }
        
        var lowerBound: Int = 0
        
        for l in locations {
            if locationY > l {
                lowerBound += 1
            }
        }
        
        return propositions[min(lowerBound, propositions.count - 1)].id
    }
    
    func getGridPosition(location: CGPoint) -> Int {
        if location.x > 150 && location.y > 150 {
            return 4
        } else if location.x > 150 && location.y < 150 {
            return 3
        } else if location.x < 150 && location.y > 150 {
            return 2
        } else if location.x < 150 && location.y < 150 {
            return 1
        } else {
            return 0
        }
    }

    
    var propositions: [Proposition]
    
    var boundsMap: [UUID : CGFloat] = [:] {
        didSet {
            print("New update to locations!")
            for proposition in propositions {
                print("proposition numer \(position(of: proposition)): \(boundsMap[proposition.id])")
            }
        }
    }
    
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
    
    mutating func updatePropositionBounds(with preferences: [PropositionPreferenceData], context: GeometryProxy) {
        for preference in preferences {
            boundsMap[preference.id] = context[preference.bounds].minY
            print("View length: \(context[preference.bounds].height)")
        }
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
