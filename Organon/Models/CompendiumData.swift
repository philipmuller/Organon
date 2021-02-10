//
//  CompendiumData.swift
//  Organon
//
//  Created by Philip Müller on 09/02/21.
//

import Foundation

struct CompendiumData {
    static func generateFirstSection() -> [Row] {
        var rows: [Row] = []
        
        var entries: [CompendiumEntry] = []
        
        let introduction = CompendiumEntry(
            title: "Introduction",
            tldr: "Una congiunzione di due proposizioni è vera se e solo se entrambi i termini congiunti sono veri",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(introduction)
        
        let simple = CompendiumEntry(
            title: "Simple Statements",
            tldr: "Una congiunzione di due proposizioni è vera se e solo se entrambi i termini congiunti sono veri",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(simple)
        
        let conjunction = CompendiumEntry(
            title: "Conjunctions",
            tldr: "Una congiunzione di due proposizioni è vera se e solo se entrambi i termini congiunti sono veri",
            requiredKnowladge: [],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A · B", "t", "f", "f", "f"]]),
                Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            ), Paragraph(
                title: "From conversation to structure",
                body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        )],
            exercises: [
                Quiz(difficulty: "EASY", completed: false, title: "Quiz", estimatedCompletionTime: 4, qa: [
                    "Domanda 1" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 2" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 3" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 4" : ["Risposta 1", "Risposta 2", "Risposta 3"]
                ]),
                
                EditorQuestion(difficulty: "EASY", completed: false, estimatedCompletionTime: 4, title: "Conversione", prompt:
                                "Prova a convertire la seguente frase in cheneso", solution: FormalData(propositions: [
                                    Proposition(content: Statement(content: "Something something", formula: "A"))
                                ]))
            ]
        )
        entries.append(conjunction)
        
        let disjunction = CompendiumEntry(
            title: "Disjunctions",
            tldr: "Una congiunzione di due proposizioni è vera se e solo se entrambi i termini congiunti sono veri",
            requiredKnowladge: [],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A v B", "t", "t", "t", "f"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(disjunction)
        
        let conditional = CompendiumEntry(
            title: "Conditionals",
            tldr: "Una congiunzione di due proposizioni è vera se e solo se entrambi i termini congiunti sono veri",
            requiredKnowladge: [],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(conditional)
        
        let negation = CompendiumEntry(
            title: "Negations",
            tldr: "Una congiunzione di due proposizioni è vera se e solo se entrambi i termini congiunti sono veri",
            requiredKnowladge: [],
            body: [Table(content: [["A", "t", "f"], ["~A", "f", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(negation)
        
        let whatever = CompendiumEntry(
            title: "Whatever",
            tldr: "Una congiunzione di due proposizioni è vera se e solo se entrambi i termini congiunti sono veri",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(whatever)
        
        if !entries.count.isMultiple(of: 2) {
            rows.append(Row(firstEntry: entries.first!, secondEntry: nil))
            entries.remove(at: 0)
        }
        
        for index in 0..<entries.count where index.isMultiple(of: 2) {
            rows.append(Row(firstEntry: entries[index], secondEntry: index + 1 < entries.count ? entries[index + 1] : nil))
        }
        
        return rows
    }
}

struct Row: Identifiable {
    let id = UUID()
    let firstEntry: CompendiumEntry
    let secondEntry: CompendiumEntry?
}
