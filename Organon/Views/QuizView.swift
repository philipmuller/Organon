//
//  QuizView.swift
//  Organon
//
//  Created by Philip Müller on 10/02/21.
//

import SwiftUI

struct QuizView: View {
    let quiz: Quiz
    @State var currentIndex: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            HStack {
                Spacer()
                questionCard
                Spacer()
            }
            
            HStack {
                Spacer()
                risposteDisponibili
                Spacer()
            }
            
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 30)
    }
    var risposteDisponibili: some View {
        VStack {
            let index = quiz.qa.index(quiz.qa.startIndex, offsetBy: currentIndex)
            let currentKey = quiz.qa.keys[index]
            let answers = quiz.qa[currentKey]!
            
            ForEach(answers, id: \.self) { answer in
                Button {
                    print("Image tapped!")
                    
                } label: {
                    Text(answer)
                        .frame(width: 330, height: 50)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    var questionCard: some View {
        VStack {
            let index = quiz.qa.index(quiz.qa.startIndex, offsetBy: currentIndex)
            Text(quiz.qa.keys[index])
                .font(.custom("AvenirNext-Medium", size: 17))
                .foregroundColor(Color("MainText"))
        }
        .frame(width: 330, height: 200)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 10)
                .opacity(0.5)
        )
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Domanda \(currentIndex + 1)/\(quiz.qa.count)")
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.custom("SabonBold", size: 28))
                    .foregroundColor(Color("MainText"))
                    .padding(.bottom, 10)
                
                //Divider()
            }
            .padding(.trailing, 30)
            
            GeometryReader() { geometry in
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Color("BoxGrey"))
                        .frame(width: geometry.size.width, height: 2)
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: (geometry.size.width/CGFloat(quiz.qa.count))*CGFloat(currentIndex+1), height: 2)
                }
                
            }
            .frame(height: 2)
        }
        .padding(.trailing, 30)
        .padding(.bottom, 30)
    }
}
