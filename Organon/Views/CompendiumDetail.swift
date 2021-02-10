//
//  CompendiumDetail.swift
//  Organon
//
//  Created by Philip Müller on 06/02/21.
//

import SwiftUI

struct CompendiumDetail: View {
    var data: CompendiumEntry
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                
                ForEach(data.body, id: \.id) { component in
                    if let content = component as? Paragraph {
                        paragraph(paragraph: content)
                            
                    }
                    
                    if let table = component as? Table {
                        truthTable(table: table)
                            .frame(width: 200, height: 100)
                            .padding(.bottom, 30)
                    }
                }
                if data.exercises.count > 0 {
                    exerciseBrowser
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
        }
        .font(.custom("AvenirNext-Medium", size: 17))
        .foregroundColor(Color("MainText"))
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(data.title)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.custom("SabonBold", size: 28))
                    .foregroundColor(Color("MainText"))
                    .padding(.bottom, 10)
                
                //Divider()
            }
            .padding(.trailing, 30)
            
            Text(data.tldr)
                .foregroundColor(Color("MainText"))
                .background(
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: 2)
                            .offset(x: -8)
                    }
                )
                .offset(x: 8)
        }
        .padding(.trailing, 30)
        .padding(.bottom, 30)
    }
    
    var exerciseBrowser: some View {
        VStack(alignment: .leading) {
            Text("Esercizi")
                .font(.custom("SabonBold", size: 22))
                .foregroundColor(Color("MainText"))
                .padding(.vertical, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    let exercises = data.exercises
                    ForEach(exercises, id: \.id) { exercise in
                        let colour = exercise.difficulty == "EASY" ? Color("Conclusion") : exercise.difficulty == "MEDIUM" ? Color("Medium") : Color("false")
                        VStack(alignment: .leading) {
                            Text(exercise.title)
                                .font(.custom("SabonBold", size: 20))
                            
                            Text(exercise.difficulty)
                                .font(.custom("AvenirNext-Bold", size: 15))
                                .foregroundColor(colour)
                            
                            VStack(alignment: .leading) {
                                if let quiz = exercise as? Quiz {
                                    Text("\(quiz.qa.count) domande")
                                        .font(.custom("AvenirNext-Medium", size: 17))
                                        .foregroundColor(Color("MainText"))
                                }
                                
                                Text("\(exercise.estimatedCompletionTime) minuti")
                                    .font(.custom("AvenirNext-Medium", size: 17))
                                    .foregroundColor(Color("MainText"))
                            }
                            .padding(.top, 5)
                        }
                        .frame(width: 170, height: 150)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(colour.opacity(0.3))
                        )
                    }
                }
            }
        }
        
    }
    
    func paragraph(paragraph: Paragraph) -> some View {
        VStack(alignment: .leading) {
            if let title = paragraph.title {
                Text(title)
                    .font(.custom("SabonBold", size: 22))
                    .foregroundColor(Color("MainText"))
                    .padding(.vertical, 10)
            }
            Text(paragraph.body)
        }
    }
    
    func truthTable(table: Table) -> some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = 30
            let numberOfRows: Int = table.content.first!.count
            let numberOfColumns: Int = table.content.count
            let separationAmountY: CGFloat = geometry.size.height/CGFloat(numberOfRows)
            let separationAmountX: CGFloat = ((geometry.size.width)/CGFloat(numberOfColumns))
            
            
            ZStack {
                VStack(spacing: separationAmountY) {
                    ForEach(1..<numberOfRows) { index in
                        Rectangle()
                            .fill(Color("BoxGrey"))
                            .frame(width: geometry.size.width, height: 1)
                    }
                }
                .offset(y: 8)
                
                HStack() {
                    ForEach(0..<table.content.count) { index in
                        column(items: table.content[index], separationAmount: separationAmountY-CGFloat(10), minWidth: separationAmountX)
                        
                        if index != table.content.count - 1 {
                            Rectangle()
                                .fill(Color("BoxGrey"))
                                .frame(width: 1, height: geometry.size.height)
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
            }
            .padding(.all, 0)
            
        }
    }
    
    func column(items: [String], separationAmount: CGFloat, minWidth: CGFloat) -> some View {
        VStack(spacing: separationAmount) {
            ForEach(items, id: \.self) { item in
                if item == "t" {
                    Circle()
                        .fill(Color("Conclusion"))
                        .frame(width: 10, height: 10)
                } else if item == "f" {
                    Circle()
                        .fill(Color("False"))
                        .frame(width: 10, height: 10)
                } else {
                    Text(item)
                        .font(.custom("SabonBold", size: 20))
                        .fixedSize(horizontal: false, vertical: true)
                        
                }
            }
        }
        .frame(minWidth: minWidth)
    }
    
    func getColumn(index: Int, array: [[String]]) -> [String] {
        return array[index]
    }
}
