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
    @State var answeredCorrectly: Bool? = nil
    @State var selectedAnswer: String? = nil
    @State var completed: Bool = false
    @State var correctAnswers: [Int] = []
    @State var shouldScroll: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(axes) {
            VStack(alignment: .leading, spacing: 20) {
                header
                
                HStack {
                    
                    if !completed {
                        Spacer()
                        ZStack {
                            ForEach(quiz.questions.reversed(), id: \.id) { question in
                                let questionIndex = quiz.questions.firstIndex(where: {q in q.id == question.id})!
                                let questionPosition = quiz.questions.index(quiz.questions.startIndex, offsetBy: questionIndex)
                                
                                questionCard(prompt: question.prompt, isActive: questionPosition == currentIndex ? true : false)
                                    .rotationEffect(Angle(degrees: Double(offsetX(position: questionPosition)/4)))
                                    .offset(x: offsetX(position: questionPosition)-8, y: offsetY(position: questionPosition))
                                    .opacity(determineOpacity(position: questionPosition))
                            }
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            if correctAnswers.count > 0 {
                                Text("\(correctAnswers.count) risposte corrette:")
                                
                                ForEach(correctAnswers, id: \.self) { index in
                                    let answer = quiz.questions[index]
                                    HStack(alignment: .top) {
                                        Text("· ")
                                        Text("\(answer.prompt)\n\(answer.solution)")
                                            .font(.custom("AvenirNext-Medium", size: 17))
                                    }
                                    
                                }
                            }
                            
                            if quiz.questions.count - correctAnswers.count > 0 {
                                Text("\(quiz.questions.count - correctAnswers.count) risposte sbagliate: ")
                                ForEach(quiz.questions, id: \.id) { question in
                                    let qIndex = quiz.questions.firstIndex(where: {q in q.id == question.id})!
                                    if !correctAnswers.contains(qIndex) {
                                        HStack(alignment: .top) {
                                            Text("· ")
                                            Text("\(question.prompt)")
                                                .font(.custom("AvenirNext-Medium", size: 17))
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                        .font(.custom("SabonBold", size: 20))
                        .foregroundColor(Color("MainText"))
                    }

                    Spacer()
                }
                
                Spacer()
                HStack{
                    Spacer()
                    let index = quiz.questions.index(quiz.questions.startIndex, offsetBy: currentIndex)
                    let currentQuestion = quiz.questions[index]
                    risposteDisponibili(risposte: currentQuestion.availableSolutions)
                    Spacer()
                }
                
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .animation(.spring())
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack
                .accentColor(Color("BoxGrey"))
            )
        }
        
    }
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            
        }) {
            Image(systemName: "chevron.backward")
                .font(Font.system(size: 23, weight: .light))
            
        }
    }
    
    private var axes: Axis.Set {
        return completed ? .vertical : []
    }
    
    func determineOpacity(position: Int) -> Double {
        if (position - currentIndex) > 3 {
            return 0
        }
        
        return Double(1-(Double(position - currentIndex)*(0.25)))
    }
    func offsetX(position: Int) -> CGFloat {
        if position < currentIndex || self.completed {
            return 370
            
        } else {
            return CGFloat(max((position - currentIndex)*(-5), -16))
        }
    }
    
    func offsetY(position: Int) -> CGFloat {
        if position < currentIndex {
            return 0
            
        } else {
            return CGFloat((position - currentIndex)*(-5))
        }
    }
    
    
    
    func risposteDisponibili(risposte: [(String, Bool)]) -> some View {
        VStack(spacing: 10) {
            if !completed {
                ForEach(risposte, id: \.0) { answer in
                    let answerText = answer.0
                    let answerValue = answer.1
                    Button {
                        self.selectedAnswer = answerText
                        
                        if answerValue == true {
                            self.answeredCorrectly = true
                            self.correctAnswers.append(currentIndex)
                        } else {
                            self.answeredCorrectly = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            self.answeredCorrectly = nil
                            self.selectedAnswer = nil
                            if self.currentIndex == quiz.questions.count - 1 {
                                self.completed = true
                            }
                            self.currentIndex = min(self.currentIndex+1, quiz.questions.count-1)
                        }
                        
                    } label: {
                        Text(answerText)
                            .font(.custom("AvenirNext-Medium", size: 17))
                            .foregroundColor(.white)
                            .frame(width: 280, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).fill((answeredCorrectly == nil) ? Color("BoxGrey") : (answeredCorrectly == true && selectedAnswer == answerText) ? Color.accentColor : (answeredCorrectly == false && selectedAnswer == answerText) ? Color("MainText") : Color("BoxGrey")))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            } else {
//                Button {
//                    self.presentationMode.wrappedValue.dismiss()
//                } label: {
//                    Text("Termina")
//                        .font(.custom("AvenirNext-Medium", size: 17))
//                        .foregroundColor(.white)
//                        .frame(width: 280, height: 50)
//                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("MainText")))
//                }
//                .buttonStyle(PlainButtonStyle())
                
                Button {
                    self.currentIndex = 0
                    self.answeredCorrectly = nil
                    self.selectedAnswer = nil
                    self.completed = false
                    self.correctAnswers = []
                    
                } label: {
                    Text("Ripeti")
                        .font(.custom("AvenirNext-Medium", size: 17))
                        .foregroundColor(.white)
                        .frame(width: 280, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                }
                .buttonStyle(PlainButtonStyle())
            }
            
        }
    }
    
    func questionCard(prompt: String, isActive: Bool) -> some View {
        VStack(spacing: 20) {
            Text(prompt)
                .font(.custom("AvenirNext-Medium", size: 17))
                .foregroundColor(Color("MainText"))
            
            if let correct = answeredCorrectly, isActive == true {
                Image(systemName: (correct ? "checkmark.square.fill" : "xmark.square.fill"))
                    .font(.title)
                    .foregroundColor(correct ? Color.accentColor : Color("MainText"))
            }
            
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 20)
        .frame(width: 330, height: 180)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color("BoxGrey"), radius: 10)
        )
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(completed ? "Quiz completato!" : "Domanda \(currentIndex + 1)/\(quiz.questions.count)")
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
                        .frame(width: (geometry.size.width/CGFloat(quiz.questions.count))*CGFloat(currentIndex+1), height: 2)
                }
                
            }
            .frame(height: 2)
        }
        .padding(.trailing, 30)
        .padding(.bottom, 30)
    }
}
