//
//  CompendiumPageData.swift
//  Organon
//
//  Created by Philip Müller on 09/02/21.
//

import Foundation

struct CompendiumEntry: Identifiable, Equatable {
    static func == (lhs: CompendiumEntry, rhs: CompendiumEntry) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    let title: String
    let tldr: String
    let requiredKnowladge: [String]
    let body: [EntryComponent]
    let exercises: [Exercise]
    
    var allExercisesCompleted: Bool {
        if exercises.isEmpty {
            return false
        }
        
        for exercise in exercises {
            if exercise.completed == false {
                return false
            }
        }
        
        return true
    }
    
}

protocol EntryComponent {
    var type: ComponentType { get }
    var id: UUID { get }
}

struct Paragraph: EntryComponent {
    var id: UUID = UUID()
    
    let type: ComponentType = .paragraph
    let title: String?
    let body: String
}

struct Example: EntryComponent {
    var id: UUID = UUID()
    
    let type: ComponentType = .example
    let content: [String : String]
}

struct Table: EntryComponent {
    var id: UUID = UUID()
    
    let type: ComponentType = .table
    let content: [[String]]
}

enum ComponentType {
    case paragraph, example, table
}

protocol Exercise {
    var type: ExerciseType { get }
    var title: String { get }
    var difficulty: String { get }
    var estimatedCompletionTime: Int { get }
    var id: UUID { get }
    var completed: Bool { get set }
}

struct Quiz: Exercise {
    let difficulty: String
    
    var completed: Bool = false
    
    let type: ExerciseType = .quitz
    let id: UUID = UUID()
    var title: String
    var estimatedCompletionTime: Int
    
    let questions: [QuizQuestion]
}

struct EditorQuestion: Exercise {
    let difficulty: String
    
    var completed: Bool = false
    
    var estimatedCompletionTime: Int
    
    let type: ExerciseType = .editor
    let id: UUID = UUID()
    let title: String
    let prompt: String
    
    let solution: FormalData
}

struct QuizQuestion {
    let id: UUID = UUID()
    let prompt: String
    let availableSolutions: [(String, Bool)]
    var solution: String {
        for answer in availableSolutions {
            if answer.1 == true {
                return answer.0
            }
        }
        
        return "No solution"
    }
}

enum ExerciseType {
    case quitz, editor
}
