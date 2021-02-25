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
            title: "Introduzione",
            tldr: "La logica studia il ragionamento, ovvero le leggi e le funzioni che caratterizzano la struttura del pensiero.",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(introduction)
        
        let simple = CompendiumEntry(
            title: "Ragionamenti",
            tldr: "Un ragionamento è una serie di premesse che portano ad una conclusione",
            requiredKnowladge: ["Introduzione"],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(simple)
        
        let conjunction = CompendiumEntry(
            title: "Proposizioni",
            tldr: "Frasi che possono essere vere o false. La struttura logica delle proposizioni è determinata da operatori logici",
            requiredKnowladge: ["Introduzione"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A · B", "t", "f", "f", "f"]]),
                Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            ), Paragraph(
                title: "From conversation to structure",
                body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        )],
            exercises: [
                Quiz(difficulty: "EASY", completed: true, title: "Quiz", estimatedCompletionTime: 4, questions: [
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame e sete\"?", availableSolutions: [("A v B", false), ("A -> B", false), ("A · B", true), ("B v A", false)]),
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame, sete e sonno\"?", availableSolutions: [("A v (B · C)", false), ("A -> (B · A)", false), ("A · B", false), ("(A · B) · C", true)]),
                    QuizQuestion(prompt: "Le frasi: \"Marco ha fame e sete\" e \"Marco ha sete e fame\" sono logicamente equivalenti?", availableSolutions: [("Sì", true), ("No", false)]),
                    QuizQuestion(prompt: "Una congiunzione è vera solo se:", availableSolutions: [("Entrambi i termini sono veri", true), ("Almeno uno dei termini è vero", false), ("Almeno uno dei termini è falso", false), ("Entrambi i termini sono falsi", false)])
                ]),
                
                EditorQuestion(difficulty: "EASY", completed: true, estimatedCompletionTime: 4, title: "Conversione", prompt:
                                "Prova a convertire la seguente frase in cheneso", solution: FormalData(propositions: [
                                    Proposition(content: Statement(content: "Something something", formula: "A"))
                                ]))
            ]
        )
        entries.append(conjunction)
        
        let disjunction = CompendiumEntry(
            title: "Inferenze",
            tldr: "Schemi di ragionamento che permettono di trarre proposizioni da proposizioni già stabilite",
            requiredKnowladge: ["Introduzione"],
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
    
    static func generateSecondSection() -> [CompendiumEntry] {
        var entries: [CompendiumEntry] = []
        
        let introduction = CompendiumEntry(
            title: "Semplici",
            tldr: "Frasi che possono essere vere o false, solitamente espresse in senso positivo.",
            requiredKnowladge: ["Proposizioni"],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(introduction)
        
        let simple = CompendiumEntry(
            title: "Negazioni",
            tldr: "La negazione di una proposizione inverte il valore della frase negata.",
            requiredKnowladge: ["Proposizioni"],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(simple)
        
        let conjunction = CompendiumEntry(
            title: "Congiunzioni",
            tldr: "La congiunzione di due proposizioni è vera soltanto quando entrambe le proposizioni sono vere",
            requiredKnowladge: ["Proposizioni"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A · B", "t", "f", "f", "f"]]),
                Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            ), Paragraph(
                title: "From conversation to structure",
                body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        )],
            exercises: [
                Quiz(difficulty: "EASY", completed: true, title: "Quiz", estimatedCompletionTime: 4, questions: [
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame e sete\"?", availableSolutions: [("A v B", false), ("A -> B", false), ("A · B", true), ("B v A", false)]),
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame, sete e sonno\"?", availableSolutions: [("A v (B · C)", false), ("A -> (B · A)", false), ("A · B", false), ("(A · B) · C", true)]),
                    QuizQuestion(prompt: "Le frasi: \"Marco ha fame e sete\" e \"Marco ha sete e fame\" sono logicamente equivalenti?", availableSolutions: [("Sì", true), ("No", false)]),
                    QuizQuestion(prompt: "Una congiunzione è vera solo se:", availableSolutions: [("Entrambi i termini sono veri", true), ("Almeno uno dei termini è vero", false), ("Almeno uno dei termini è falso", false), ("Entrambi i termini sono falsi", false)])
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
            tldr: "La disgiunzione di due proposizioni è falsa soltanto quando entrambe le proposizioni sono false.",
            requiredKnowladge: ["Proposizioni"],
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
            tldr: "La proposizione condizionale è falsa solo quando l’antecedente è vero e il conseguente è falso. La proposizione “se” è l’antecedente, la proposizione “allora” è il conseguente.",
            requiredKnowladge: ["Proposizioni"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(conditional)
        
        let n6 = CompendiumEntry(
            title: "Proposizioni comuni",
            tldr: "Le frasi nella lingua parlata possono essere espresse con combinazioni di congiunzioni logiche.",
            requiredKnowladge: ["Proposizioni"],
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
            title: "Modus ponens",
            tldr: "Se A è vero, allora B è vero. A è vero. Quindi, B è vero.",
            requiredKnowladge: ["Condizionali"],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(introduction)
        
        let simple = CompendiumEntry(
            title: "Modus tollens",
            tldr: "Se A è vero, allora B è vero. B è falso. Quindi, A è falso.",
            requiredKnowladge: ["Condizionali"],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(simple)
        
        let conjunction = CompendiumEntry(
            title: "Sillogismo disgiuntivo",
            tldr: "A e B non sono entrambi falsi. B è falso. Quindi, A è vero.",
            requiredKnowladge: ["Disgiunzioni"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A · B", "t", "f", "f", "f"]]),
                Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            ), Paragraph(
                title: "From conversation to structure",
                body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        )],
            exercises: [
                Quiz(difficulty: "EASY", completed: true, title: "Quiz", estimatedCompletionTime: 4, questions: [
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame e sete\"?", availableSolutions: [("A v B", false), ("A -> B", false), ("A · B", true), ("B v A", false)]),
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame, sete e sonno\"?", availableSolutions: [("A v (B · C)", false), ("A -> (B · A)", false), ("A · B", false), ("(A · B) · C", true)]),
                    QuizQuestion(prompt: "Le frasi: \"Marco ha fame e sete\" e \"Marco ha sete e fame\" sono logicamente equivalenti?", availableSolutions: [("Sì", true), ("No", false)]),
                    QuizQuestion(prompt: "Una congiunzione è vera solo se:", availableSolutions: [("Entrambi i termini sono veri", true), ("Almeno uno dei termini è vero", false), ("Almeno uno dei termini è falso", false), ("Entrambi i termini sono falsi", false)])
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
            tldr: "Se A è vero, allora B è vero. Se B è vero, allora C è vero. Quindi, se A è vero, allora C è vero",
            requiredKnowladge: ["Condizionali"],
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
    
    static func generateFourthSection() -> [CompendiumEntry] {
        var entries: [CompendiumEntry] = []
        
        let introduction = CompendiumEntry(
            title: "Addizione",
            tldr: "A è vero. Quindi A o B è vero.",
            requiredKnowladge: ["Disgiunzioni"],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(introduction)
        
        let simple = CompendiumEntry(
            title: "Associazione",
            tldr: "L’ordine di congiunzioni o disgiunzioni concatenate è irrilevante.",
            requiredKnowladge: ["Inferenze"],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(simple)
        
        let conjunction = CompendiumEntry(
            title: "Dilemma costruttivo",
            tldr: "Se A è vero allora B è vero e se C è vero allora D è vero. A e C non sono entrambi falsi. Quindi, B e D non sono entrambi falsi.",
            requiredKnowladge: ["Condizionali"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A · B", "t", "f", "f", "f"]]),
                Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            ), Paragraph(
                title: "From conversation to structure",
                body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        )],
            exercises: [
                Quiz(difficulty: "EASY", completed: true, title: "Quiz", estimatedCompletionTime: 4, questions: [
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame e sete\"?", availableSolutions: [("A v B", false), ("A -> B", false), ("A · B", true), ("B v A", false)]),
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame, sete e sonno\"?", availableSolutions: [("A v (B · C)", false), ("A -> (B · A)", false), ("A · B", false), ("(A · B) · C", true)]),
                    QuizQuestion(prompt: "Le frasi: \"Marco ha fame e sete\" e \"Marco ha sete e fame\" sono logicamente equivalenti?", availableSolutions: [("Sì", true), ("No", false)]),
                    QuizQuestion(prompt: "Una congiunzione è vera solo se:", availableSolutions: [("Entrambi i termini sono veri", true), ("Almeno uno dei termini è vero", false), ("Almeno uno dei termini è falso", false), ("Entrambi i termini sono falsi", false)])
                ]),
                
                EditorQuestion(difficulty: "EASY", completed: true, estimatedCompletionTime: 4, title: "Conversione", prompt:
                                "Prova a convertire la seguente frase in cheneso", solution: FormalData(propositions: [
                                    Proposition(content: Statement(content: "Something something", formula: "A"))
                                ]))
            ]
        )
        entries.append(conjunction)
        
        let disjunction = CompendiumEntry(
            title: "Commutazioni",
            tldr: "L’ordine delle proposizioni collegate da una congiunzione o disgiunzione può essere invertito.",
            requiredKnowladge: ["Inferenze"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A v B", "t", "t", "t", "f"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(disjunction)
        
        let conditional = CompendiumEntry(
            title: "Congiunzione",
            tldr: "A è vero. B è vero. Quindi, A e B è vero.",
            requiredKnowladge: ["Congiunzioni"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(conditional)
        
        let n6 = CompendiumEntry(
            title: "Distribuzione",
            tldr: "Le regole sulla distribuzione affrontano relazioni tra congiunzioni e disgiunzioni.",
            requiredKnowladge: ["Inferenze"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(n6)
        
        let n7 = CompendiumEntry(
            title: "Legge di De Morgan",
            tldr: "Non è vero che almeno uno tra A e B è vero. Quindi, A è falso e B è falso. Non è vero che A e B sono entrambi veri. Quindi, A è falso e B è falso non sono entrambe affermazioni false.",
            requiredKnowladge: ["Disgiunzioni"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(n7)
        
        let n8 = CompendiumEntry(
            title: "Tautologia",
            tldr: "La tautologia come inferenza viene usata molto raramente, e quando viene usata è solitamente solo per soddisfare alcuni criteri necessari alla continuazione di altre inferenze. A è vero e A è vero è equivalente a A è vero. A e A non sono entrambi falsi è equivalente a A è vero.",
            requiredKnowladge: ["Inferenze"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(n8)
        
        let n20 = CompendiumEntry(
            title: "Semplificazioni",
            tldr: "A e B sono entrambi veri. Quindi, B è vero (B può essere sostituito da A, considerando la commutazione)",
            requiredKnowladge: ["Congiunzioni"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(n20)
        
        let n9 = CompendiumEntry(
            title: "Trasposizione",
            tldr: "Se A è vero allora B è vero è equivalente a se B non è vero allora A non è vero.",
            requiredKnowladge: ["Condizionali"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(n9)
        
        let n11 = CompendiumEntry(
            title: "Doppia negazione",
            tldr: "La doppia negazione di una proposizione può essere ignorata. Non è vero che A è falso. Quindi, A è vero.",
            requiredKnowladge: ["Negazioni"],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(n11)
        
        let n10 = CompendiumEntry(
            title: "Implicazione materiale",
            tldr: "A e B non sono entrambi falsi è logicamente equivalente a se A è falso, allora B è vero.",
            requiredKnowladge: [],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(n10)
        
        let n12 = CompendiumEntry(
            title: "Esportazione",
            tldr: "Una concatenazione di due condizionali è equivalente al condizionale che ha come antecedente la congiunzione dei due antecedenti, e come conseguente il conseguente del condizionale finale.",
            requiredKnowladge: [],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(n12)
        
        return entries
    }
    
    static func generateFifthSection() -> [CompendiumEntry] {
        var entries: [CompendiumEntry] = []
        
        let introduction = CompendiumEntry(
            title: "Prova condizionale",
            tldr: "Una dimostrazione che parte da una supposizione per poi derivarne una proposizione condizionale alla fine, con la supposizione che funge da antecedente.",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(introduction)
        
        let simple = CompendiumEntry(
            title: "Dimostrazione per assurdo",
            tldr: "Una dimostrazione che parte da una supposizione per poi arrivare ad una contraddizione e negare quindi la supposizione presentata.",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(simple)
        
        return entries
    }
    
    static func generateSixthSection() -> [CompendiumEntry] {
        var entries: [CompendiumEntry] = []
        
        let introduction = CompendiumEntry(
            title: "Introduzione",
            tldr: "Le fallacie logiche sono schemi di ragionamento inaffidabili.",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(introduction)
        
        let simple = CompendiumEntry(
            title: "Formali",
            tldr: "Le fallacie formali hanno a che fare con la struttura e la validità di ragionamenti deduttivi.",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(simple)
        
        let conjunction = CompendiumEntry(
            title: "Informali",
            tldr: "Le fallacie informali sono una categoria ampia che comprende schemi di ragionamento inaffidabili nella giustificazione delle premesse o in un contesto discorsivo.",
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
                Quiz(difficulty: "EASY", completed: true, title: "Quiz", estimatedCompletionTime: 4, questions: [
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame e sete\"?", availableSolutions: [("A v B", false), ("A -> B", false), ("A · B", true), ("B v A", false)]),
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame, sete e sonno\"?", availableSolutions: [("A v (B · C)", false), ("A -> (B · A)", false), ("A · B", false), ("(A · B) · C", true)]),
                    QuizQuestion(prompt: "Le frasi: \"Marco ha fame e sete\" e \"Marco ha sete e fame\" sono logicamente equivalenti?", availableSolutions: [("Sì", true), ("No", false)]),
                    QuizQuestion(prompt: "Una congiunzione è vera solo se:", availableSolutions: [("Entrambi i termini sono veri", true), ("Almeno uno dei termini è vero", false), ("Almeno uno dei termini è falso", false), ("Entrambi i termini sono falsi", false)])
                ]),
                
                EditorQuestion(difficulty: "EASY", completed: true, estimatedCompletionTime: 4, title: "Conversione", prompt:
                                "Prova a convertire la seguente frase in cheneso", solution: FormalData(propositions: [
                                    Proposition(content: Statement(content: "Something something", formula: "A"))
                                ]))
            ]
        )
        entries.append(conjunction)
        
        return entries
    }
    
    static func generateSeventhSection() -> [CompendiumEntry] {
        var entries: [CompendiumEntry] = []
        
        let introduction = CompendiumEntry(
            title: "Affermare il conseguente",
            tldr: "Inferenza invalida. Se A è vero allora B è vero. B è vero. Quindi, A è vero.",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(introduction)
        
        let simple = CompendiumEntry(
            title: "Negare l’antecedente",
            tldr: "Inferenza invalida. Se A è vero allora B è vero. A è falso. Quindi, B è falso.",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(simple)
        
        let conjunction = CompendiumEntry(
            title: "Affermare il disgiunto",
            tldr: "Inferenza invalida. A e B non sono entrambi falsi. A è vero. Quindi, B è falso.",
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
                Quiz(difficulty: "EASY", completed: true, title: "Quiz", estimatedCompletionTime: 4, questions: [
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame e sete\"?", availableSolutions: [("A v B", false), ("A -> B", false), ("A · B", true), ("B v A", false)]),
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame, sete e sonno\"?", availableSolutions: [("A v (B · C)", false), ("A -> (B · A)", false), ("A · B", false), ("(A · B) · C", true)]),
                    QuizQuestion(prompt: "Le frasi: \"Marco ha fame e sete\" e \"Marco ha sete e fame\" sono logicamente equivalenti?", availableSolutions: [("Sì", true), ("No", false)]),
                    QuizQuestion(prompt: "Una congiunzione è vera solo se:", availableSolutions: [("Entrambi i termini sono veri", true), ("Almeno uno dei termini è vero", false), ("Almeno uno dei termini è falso", false), ("Entrambi i termini sono falsi", false)])
                ]),
                
                EditorQuestion(difficulty: "EASY", completed: true, estimatedCompletionTime: 4, title: "Conversione", prompt:
                                "Prova a convertire la seguente frase in cheneso", solution: FormalData(propositions: [
                                    Proposition(content: Statement(content: "Something something", formula: "A"))
                                ]))
            ]
        )
        entries.append(conjunction)
        
        return entries
    }
    
    static func generateEigthSection() -> [CompendiumEntry] {
        var entries: [CompendiumEntry] = []
        
        let introduction = CompendiumEntry(
            title: "Equivocazione",
            tldr: "Utilizzare la stessa parola nel ragionamento per identificare due concetti diversi. ",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(introduction)
        
        let simple = CompendiumEntry(
            title: "Composizione e divisione",
            tldr: "Concludere che una proprietà posseduta da un intero/una parte deve essere posseduta anche dalle parti che lo compongono/l’intero.",
            requiredKnowladge: [],
            body: [Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(simple)
        
        let conjunction = CompendiumEntry(
            title: "Argomento fantoccio",
            tldr: "Un rappresentazione errata o distorta di un ragionamento, volta a semplificare la confutazione del ragionamento.",
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
                Quiz(difficulty: "EASY", completed: true, title: "Quiz", estimatedCompletionTime: 4, questions: [
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame e sete\"?", availableSolutions: [("A v B", false), ("A -> B", false), ("A · B", true), ("B v A", false)]),
                    QuizQuestion(prompt: "Quale schema logico corrisponde alla frase: \"Marco ha fame, sete e sonno\"?", availableSolutions: [("A v (B · C)", false), ("A -> (B · A)", false), ("A · B", false), ("(A · B) · C", true)]),
                    QuizQuestion(prompt: "Le frasi: \"Marco ha fame e sete\" e \"Marco ha sete e fame\" sono logicamente equivalenti?", availableSolutions: [("Sì", true), ("No", false)]),
                    QuizQuestion(prompt: "Una congiunzione è vera solo se:", availableSolutions: [("Entrambi i termini sono veri", true), ("Almeno uno dei termini è vero", false), ("Almeno uno dei termini è falso", false), ("Entrambi i termini sono falsi", false)])
                ]),
                
                EditorQuestion(difficulty: "EASY", completed: true, estimatedCompletionTime: 4, title: "Conversione", prompt:
                                "Prova a convertire la seguente frase in cheneso", solution: FormalData(propositions: [
                                    Proposition(content: Statement(content: "Something something", formula: "A"))
                                ]))
            ]
        )
        entries.append(conjunction)
        
        let disjunction = CompendiumEntry(
            title: "Ad hominem",
            tldr: "Una deviazione retorica che si pone come contestazione di un ragionamento, quando in realtà contesta l’interlocutore stesso.",
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
            title: "Ragionamento circolare",
            tldr: "Un argomento in cui le premesse vengono giustificate assumendo la conclusione.",
            requiredKnowladge: [],
            body: [Table(content: [["A", "t", "t", "f", "f"],["B", "t", "f", "t", "f"],["A -> B", "t", "f", "t", "t"]]),
                   Paragraph(
                    title: nil,
                    body: "Phasellus purus. Etiam sapien. Duis diam urna, iaculis ut, vehicula ac, varius sit amet, mi. Donec id nisl. Aliquam erat volutpat. Integer fringilla. Duis lobortis, quam non volutpat suscipit, magna sem consequat libero, ac hendrerit urna ante id mi. Quisque commodo facilisis tellus. Integer sodales lorem sed nisl. Morbi consectetuer mauris quis odio. Ut dolor lorem, viverra vitae, viverra eu, euismod nec, enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            )],
            exercises: []
        )
        entries.append(conditional)
        
        return entries
    }
}

struct Row: Identifiable {
    let id = UUID()
    let firstEntry: CompendiumEntry
    let secondEntry: CompendiumEntry?
}
