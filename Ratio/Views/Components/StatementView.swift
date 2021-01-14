//
//  StatementView.swift
//  Ratio
//
//  Created by Philip Müller on 17/12/20.
//

import SwiftUI

struct StatementView: View {
    @State var statement: Statement
    @State var text: String = ""
    @Binding var deleteCount: Int
    let editable: Bool// = false
    
    
    var body: some View {
        
        VStack {
            //Text("text: \(text), deletecount: \(deleteCount)")
            //Text("statement text: \(statement.content ?? "complex")")
            
            if let cStatement = statement as? ComplexStatement {
                switch cStatement.csType {
                case .ifthen:
                        ifThenStatement
                            .transition(.scale)// C -> E
                            .onAppear() {
                                //text = cStatement.complexContent
                            }
                case .and:
                        andStatement
                            .transition(.scale)
                            .onAppear() {
                                //text = cStatement.complexContent
                            }
                case .or:
                        orStatement
                            .transition(.scale)
                            .onAppear() {
                                //text = cStatement.complexContent
                            }
                case .negation:
                        notStatement
                            .transition(.scale)
                            .onAppear() {
                                //text = cStatement.complexContent
                            }
                }
                
            } else {
                Text(statement.content ?? "error")
                    .transition(.scale)
                    .fixedSize(horizontal: false, vertical: true)
                    .onAppear() {
                        //text = statement.content!
                    }
            }
        }
    }
    
    var ifThenStatement: some View {
        let statement = self.statement as! ComplexStatement
        let first = statement.childStatements.first!
        let second = statement.childStatements.last!
        let firstView = StatementView(statement: first, deleteCount: $deleteCount, editable: editable)
        let secondView = StatementView(statement: second, deleteCount: $deleteCount, editable: editable)
            
        return VStack(alignment: .leading, spacing: 4) {
            
            
            ZStack(alignment: .bottomLeading) {
                HStack(alignment: .top) {
                    Image("if")
                        .foregroundColor(Color.accentColor)
                        .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: first.id, modifier: 0)]
                        }
                    firstView
                        .transformAnchorPreference(key: StatementPreferenceKey.self, value: .bounds, transform: { (value, anchor) in
                            value.removeAll()
                        })
                }
                
                Rectangle()
                    .frame(width: 0, height: 0)
                    .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                        return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                    }
            }
            
            
            HStack(alignment: .top) {
                ZStack(alignment:.bottomLeading) {
                    Image("then")
                        .foregroundColor(Color.accentColor)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
                        
                    Rectangle()
                        .frame(width: 0, height: 0)
                        .padding(.bottom, 2)
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: second.id, modifier: 0)]
                        }
                    
                }
                secondView
                    .transformAnchorPreference(key: StatementPreferenceKey.self, value: .bounds, transform: { (value, anchor) in
                        value.removeAll()
                    })
            }
        }
        .backgroundPreferenceValue(StatementPreferenceKey.self) { preferences in
            GeometryReader { geometry in
                ConnectiveLines(geometry: geometry, preferences: filterPreferences(firstChild: first, secondChild: second, preferences: preferences), depth: 0)
                    .padding(EdgeInsets(top: 0, leading: -2, bottom: 0, trailing: 0))
                    .accentColor(deleteCount == 0 ? Color(red: 0.6, green: 0.5, blue: 0.1, opacity: 1) : Color.red)
                //Text("C: \(deleteCount == 0 ? "accent" : "red")")
            }
            
        }
    }
    
    var andStatement: some View {
        let statement = self.statement as! ComplexStatement
        let firstStatement = statement.childStatements.first!
        let lastStatement = statement.childStatements.last!
        let firstView = StatementView(statement: firstStatement, text: statement.complexContent, deleteCount: $deleteCount, editable: editable)
        let secondView = StatementView(statement: lastStatement, text: statement.complexContent, deleteCount: $deleteCount, editable: editable)
        
        return HStack {
            if statement.block && firstStatement.block {
                VStack(alignment: .leading) {
                    firstView
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                        
                    Image("and").foregroundColor(Color.accentColor)
                        .padding(1)
                        .background(Color.white)
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                        }
                    
                    secondView
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
   
                }
                .backgroundPreferenceValue(StatementPreferenceKey.self) { preferences in
                    GeometryReader { geometry in
                        ConnectiveLines(geometry: geometry, preferences: filterPreferences(firstChild: firstStatement, secondChild: lastStatement, preferences: preferences))
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                    }
                }
            } else {
                if editable {
//                    MultilineTextField("placeholder", text: $text, onCommit: {
//                        print("Final text: \(text)")
//                    })
                    
                    MultilineTextField(bindedStatement: self.$statement, deleteTracker: $deleteCount, text: $text)
                        .padding(0)
                        //.background(Color.red.opacity(0.5))
                } else {
                    (Text(statement.leftContent)+Text(Image("and")).foregroundColor(Color.accentColor)+Text(statement.rightContent))
                        .fixedSize(horizontal: false, vertical: true)
                        //.background(Color.blue.opacity(0.5))
                }
                
                
            }
        }
    }
    
    var orStatement: some View {
        let statement = self.statement as! ComplexStatement
        let firstStatement = statement.childStatements.first!
        let lastStatement = statement.childStatements.last!
        let firstView = StatementView(statement: firstStatement, text: statement.complexContent, deleteCount: $deleteCount, editable: editable)
        let secondView = StatementView(statement: lastStatement, text: statement.complexContent, deleteCount: $deleteCount, editable: editable)
        
        return HStack {
            if statement.block && firstStatement.block {
                VStack(alignment: .leading) {
                    firstView
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                        
                    Image("or").foregroundColor(Color.accentColor)
                        .padding(1)
                        .background(Color.white)
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                        }
                    
                    secondView
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
   
                }
                .backgroundPreferenceValue(StatementPreferenceKey.self) { preferences in
                    GeometryReader { geometry in
                        ConnectiveLines(geometry: geometry, preferences: filterPreferences(firstChild: firstStatement, secondChild: lastStatement, preferences: preferences))
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                    }
                }
            } else {
                ZStack {
                    (Text(text) + Text(Image("or")).foregroundColor(Color.accentColor) + Text(statement.rightContent))
                        .fixedSize(horizontal: false, vertical: true)
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                        }
                    
                    TextEditor(text: $text)
                }
                
                
            }
        }
    }
    
    var notStatement: some View {
        let statement = self.statement as! ComplexStatement
        let nStatement = statement.childStatements.first!
        let nView = StatementView(statement: nStatement, text: statement.complexContent, deleteCount: $deleteCount, editable: editable)
        
        return VStack {
            if statement.block {
                    nView
                        .transformAnchorPreference(key: StatementPreferenceKey.self, value: .bounds, transform: { (value, anchor) in
                            for item in value {
                                if item.statementId == nStatement.id {
                                    let new = StatementPreferenceData(bounds: item.bounds, statementId: statement.id, modifier: 0)
                                    value.append(new)
                                }
                            }
                        })
                        .backgroundPreferenceValue(StatementPreferenceKey.self) { preferences in
                            GeometryReader { geometry in
                                positionSymbol(childStatement: nStatement, geometry: geometry, preferences: preferences)
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 0))
            } else {
                (~nStatement).0
                    .fixedSize(horizontal: false, vertical: true)
                    .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                        return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                    }
            }
        }
    }
    
    func positionSymbol(childStatement: Statement, geometry: GeometryProxy, preferences: [StatementPreferenceData]) -> some View {
        
        ForEach(preferences, id: \.id) { statementPreference in
            if statementPreference.statementId == childStatement.id {
                Image("not")
                    .foregroundColor(Color.accentColor)
                    .position(y: geometry[statementPreference.bounds].midY)
                    .offset(x: -15, y: 0)
            }
        }
    }
    
    func filterPreferences(firstChild: Statement, secondChild: Statement, preferences: [StatementPreferenceData]) -> [StatementPreferenceData] {
        var relevantStatementData: [StatementPreferenceData] = []
        
        for statementPreference in preferences {
            if statementPreference.statementId == firstChild.id || statementPreference.statementId == secondChild.id {
                relevantStatementData.append(statementPreference)
            }
        }
        
        return relevantStatementData
    }
    
    
}


extension Statement {
    
    static func +(lhs: Statement, rhs: Statement) -> (Text?, Text?) {
            if lhs.type == .simple && rhs.type == .simple {
                return (Text(lhs.content!)+Text(" ")+Text(Image("and")).foregroundColor(Color.accentColor)+Text(" ")+Text(rhs.content!), Text(lhs.symbol!)+Text(" ")+Text(Image("and")).foregroundColor(Color.accentColor)+Text(" ")+Text(rhs.symbol!))
            } else {
                return cViewUnion(type: .and, leftStatement: lhs, rightStatement: rhs)
            }
        
    }
    
    static func /(lhs: Statement, rhs: Statement) -> (Text?, Text?) {
            if lhs.type == .simple && rhs.type == .simple {
                return (Text(lhs.content!)+Text(" ")+Text(Image("or")).foregroundColor(Color.accentColor)+Text(" ")+Text(rhs.content!), Text(lhs.symbol!)+Text(" ")+Text(Image("or")).foregroundColor(Color.accentColor)+Text(" ")+Text(rhs.symbol!))
            } else {
                return cViewUnion(type: .or, leftStatement: lhs, rightStatement: rhs) // lhs = B, rhs = (C -> D)
            }
    }
    
    static func >(lhs: Statement, rhs: Statement) -> (Text?, Text?) {
        if lhs.type == .simple && rhs.type == .simple {
            return (Text(lhs.content!)+Text(" ")+Text(Image("then")).foregroundColor(Color.accentColor)+Text(" ")+Text(rhs.content!), Text(lhs.symbol!)+Text(" ")+Text(Image("then")).foregroundColor(Color.accentColor)+Text(" ")+Text(rhs.symbol!))
            } else {
                return cViewUnion(type: .ifthen, leftStatement: lhs, rightStatement: rhs) // lhs = B, rhs = (C -> D)
            }
    }
    
    static prefix func ~(value: Statement) -> (Text?, Text?) {
        if value.type == .simple {
            return (Text(" ")+Text(Image("not")).foregroundColor(Color.accentColor)+Text(" ")+Text(value.content!), Text(" ")+Text(Image("not")).foregroundColor(Color.accentColor)+Text(" ")+Text(value.symbol!))
            } else {
                return cViewUnion(type: .negation, leftStatement: value, rightStatement: value) // lhs = B, rhs = (C -> D)
            }
    }
    
    static func cViewUnion(type: ComplexStatementType, leftStatement: Statement, rightStatement: Statement) -> (Text?, Text?) {
        //one or both are complex statements
        var finalLeft:(Text?, Text?)
        var finalRight:(Text?, Text?)
        
        if let lCStatement = leftStatement as? ComplexStatement { //A, not a complex statement //B, not complex
            //create statement views for the left two terms:
            let oneLeft = lCStatement.childStatements.first!
            let twoLeft = lCStatement.childStatements.last!
            
            finalLeft = statementTextViewUnion(type: lCStatement.csType, first: oneLeft, second: twoLeft)
        } else {
            finalLeft = (Text(leftStatement.content!), Text(leftStatement.symbol!))
            //this triggers for A and B
        }
        
        if let rCStatement = rightStatement as? ComplexStatement { //(B · (C -> D)), //(C -> D)
            //create statement views for the right two terms:
            let oneRight = rCStatement.childStatements.first! //B //C
            let twoRight = rCStatement.childStatements.last! //(C -> D) //D
    
            finalRight = statementTextViewUnion(type: rCStatement.csType, first: oneRight, second: twoRight) //
        } else {
            finalRight = (Text(rightStatement.content!), Text(rightStatement.symbol!))
        }
        
        var op = Text(" ")+Text(Image("and"))+Text(" ")
        
        switch type {
        case .and:
            op = Text(" ")+Text(Image("and"))+Text(" ")
        case .negation:
            op = Text(" ")+Text(Image("not"))+Text(" ")
        case .or:
            op = Text(" ")+Text(Image("or"))+Text(" ")
        case .ifthen:
            op = Text(" ")+Text(Image("then"))+Text(" ")
        default:
            op = Text(" ")+Text(Image("and"))+Text(" ")
        }
        
        op = op.foregroundColor(Color.accentColor).font(Font.body.weight(.heavy))
        
        var finalText: Text?
        var finalSymbol: Text?
    
        
        if let uFinalLeft = finalLeft.0 {
            finalText = uFinalLeft
        }
        if let uFinalRight = finalRight.0 {
            if finalText == nil {
                finalText = op+uFinalRight
            } else {
                finalText = finalText! + op + uFinalRight
            }
        }
        
        if let uFinalLeft = finalLeft.1 {
            finalSymbol = Text("(") + uFinalLeft + Text(")")
        }
        if let uFinalRight = finalRight.1 {
            if finalSymbol == nil || type == .negation {
                finalSymbol = op+Text("(")+uFinalRight+Text(")")
            } else {
                finalSymbol = finalSymbol! + op + Text("(")+uFinalRight+Text(")")
            }
        }
        
        return (finalText, finalSymbol)
    }
    
    static func statementTextViewUnion(type: ComplexStatementType, first: Statement, second: Statement) -> (Text?, Text?) {
        switch type {
        case .and:
            return (first + second) // B + (C -> D)
            
        case .or:
            return (first / second)
            
        case .negation:
            return (~first)
            
        case .ifthen:
            return (first > second)

        default:
           return (nil, nil)
        }
    }
    
    
}

struct StatementPreferenceData: Identifiable {
    let id = UUID()
    let bounds: Anchor<CGRect>
    let statementId: UUID
    let modifier: Int
}

struct StatementPreferenceKey: PreferenceKey {
    typealias Value = [StatementPreferenceData]
    
    static var defaultValue: [StatementPreferenceData] = []
    
    static func reduce(value: inout [StatementPreferenceData], nextValue: () -> [StatementPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

//struct StatementView_Previews: PreviewProvider {
//    @State var count: Int = 0
//    
//    static var previews: some View {
//        StatementView(statement: Statement(text: "LALALALA", symbol: "L"), text: "", deleteCount: $count, editable: false)
//    }
//}
