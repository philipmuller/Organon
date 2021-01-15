//
//  StatementView.swift
//  Ratio
//
//  Created by Philip Müller on 17/12/20.
//

import SwiftUI

struct StatementView: View {
    @Binding var statement: Statement
    @State var text: String = ""
    @Binding var deleteCount: Int
    let editable: Bool// = false
    
    
    var body: some View {
        VStack {
            switch statement.type {
            case .conditional:
                ifThenStatement
                    .transition(.scale)
                
            case .conjunction:
                andStatement
                    .transition(.scale)
                
            case .disjunction:
                orStatement
                    .transition(.scale)
                
            case .negation:
                notStatement
                    .transition(.scale)
                
            default:
                Text(statement.content)
                    .transition(.scale)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    var ifThenStatement: some View {
        let conditionalBinding = Binding<Conditional>(get: {statement as! Conditional}, set: {statement = $0})
        let first = conditionalBinding.wrappedValue.firstChild
        let second = conditionalBinding.wrappedValue.secondChild
        let firstView = StatementView(statement: conditionalBinding.firstChild, deleteCount: $deleteCount, editable: editable)
        let secondView = StatementView(statement: conditionalBinding.secondChild, deleteCount: $deleteCount, editable: editable)
            
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
                        .transformAnchorPreference(key: StatementPreferenceKey.self, value: .bounds) { (value, anchor) in
                            value.removeAll()
                        }
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
            }
        }
    }
    
    var andStatement: some View {
        let conjunctionBinding = Binding<Conjunction>(get: {statement as! Conjunction}, set: {statement = $0})
        let firstStatement = conjunctionBinding.wrappedValue.firstChild
        let lastStatement = conjunctionBinding.wrappedValue.secondChild
        let firstView = StatementView(statement: conjunctionBinding.firstChild, text: statement.content, deleteCount: $deleteCount, editable: editable)
        let secondView = StatementView(statement: conjunctionBinding.secondChild, text: statement.content, deleteCount: $deleteCount, editable: editable)
        
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
                    StatementTextEditor(bindedStatement: self.$statement, deleteTracker: $deleteCount, text: $text)
                        .padding(0)
                } else {
                    (Text(conjunctionBinding.wrappedValue.leftContent)+Text(Image("and")).foregroundColor(Color.accentColor)+Text(conjunctionBinding.wrappedValue.rightContent))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    var orStatement: some View {
        let disjunctionBinding = Binding<Disjunction>(get: {statement as! Disjunction}, set: {statement = $0})
        let firstStatement = disjunctionBinding.wrappedValue.firstChild
        let lastStatement = disjunctionBinding.wrappedValue.secondChild
        let firstView = StatementView(statement: disjunctionBinding.firstChild, text: statement.content, deleteCount: $deleteCount, editable: editable)
        let secondView = StatementView(statement: disjunctionBinding.secondChild, text: statement.content, deleteCount: $deleteCount, editable: editable)
        
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
                    (Text(disjunctionBinding.wrappedValue.leftContent) + Text(Image("or")).foregroundColor(Color.accentColor) + Text(disjunctionBinding.wrappedValue.rightContent))
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
        let negationBinding = Binding<Negation>(get: {statement as! Negation}, set: {statement = $0})
        let nStatement = negationBinding.wrappedValue.negatedStatement
        let nView = StatementView(statement: negationBinding.negatedStatement, text: negationBinding.wrappedValue.negatedStatementContent, deleteCount: $deleteCount, editable: editable)
        
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
                (Text(Image("not")).foregroundColor(Color.accentColor) + Text(nStatement.content))
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
