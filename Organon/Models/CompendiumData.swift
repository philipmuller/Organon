//
//  CompendiumData.swift
//  Organon
//
//  Created by Philip Müller on 09/02/21.
//

import Foundation

struct CompendiumData {
    static func generateFirstSection() -> [CompendiumEntry] {
        var entries: [CompendiumEntry] = []
        
        let introduction = CompendiumEntry(
            title: "Logica?",
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
            title: "Tipi di ragionamento",
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
            title: "Ragionamenti deduttivi",
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
                Quiz(difficulty: "EASY", completed: true, title: "Quiz", estimatedCompletionTime: 4, qa: [
                    "Domanda 1" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 2" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 3" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 4" : ["Risposta 1", "Risposta 2", "Risposta 3"]
                ]),
                
                EditorQuestion(difficulty: "EASY", completed: true, estimatedCompletionTime: 4, title: "Conversione", prompt:
                                "Prova a convertire la seguente frase in cheneso", solution: FormalData(propositions: [
                                    Proposition(content: Statement(content: "Something something", formula: "A"))
                                ]))
            ]
        )
        entries.append(conjunction)
        
        let disjunction = CompendiumEntry(
            title: "Frasi logiche",
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
            title: "Inferenze",
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
            title: "Ragionamenti",
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
        
        return entries
    }
    
    static func generateSecondSection() -> [CompendiumEntry] {
        var entries: [CompendiumEntry] = []
        
        let introduction = CompendiumEntry(
            title: "Semplici",
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
            title: "Negazioni",
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
            title: "Congiunzioni",
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
                Quiz(difficulty: "EASY", completed: true, title: "Quiz", estimatedCompletionTime: 4, qa: [
                    "Domanda 1" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 2" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 3" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 4" : ["Risposta 1", "Risposta 2", "Risposta 3"]
                ]),
                
                EditorQuestion(difficulty: "EASY", completed: true, estimatedCompletionTime: 4, title: "Conversione", prompt:
                                "Prova a convertire la seguente frase in cheneso", solution: FormalData(propositions: [
                                    Proposition(content: Statement(content: "Something something", formula: "A"))
                                ]))
            ]
        )
        entries.append(conjunction)
        
        let disjunction = CompendiumEntry(
            title: "Disgiunzioni",
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
            title: "Condizionali",
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
        
        let n6 = CompendiumEntry(
            title: "Combinazioni",
            tldr: "Una congiunzione di due proposizioni è vera se e solo se entrambi i termini congiunti sono veri",
            requiredKnowladge: [],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(n6)
        
        return entries
    }
    
    static func generateThirdSection() -> [CompendiumEntry] {
        var entries: [CompendiumEntry] = []
        
        let introduction = CompendiumEntry(
            title: "Modus Ponens",
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
            title: "Modus Tollens",
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
            title: "Sillogismo disgiuntivo",
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
                Quiz(difficulty: "EASY", completed: true, title: "Quiz", estimatedCompletionTime: 4, qa: [
                    "Domanda 1" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 2" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 3" : ["Risposta 1", "Risposta 2", "Risposta 3"],
                    "Domanda 4" : ["Risposta 1", "Risposta 2", "Risposta 3"]
                ]),
                
                EditorQuestion(difficulty: "EASY", completed: true, estimatedCompletionTime: 4, title: "Conversione", prompt:
                                "Prova a convertire la seguente frase in cheneso", solution: FormalData(propositions: [
                                    Proposition(content: Statement(content: "Something something", formula: "A"))
                                ]))
            ]
        )
        entries.append(conjunction)
        
        let disjunction = CompendiumEntry(
            title: "Sillogismo ipotetico",
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
        
        return entries
    }
}

struct Row: Identifiable {
    let id = UUID()
    let firstEntry: CompendiumEntry
    let secondEntry: CompendiumEntry?
}
