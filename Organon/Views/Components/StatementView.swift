//
//  StatementView.swift
//  Ratio
//
//  Created by Philip Müller on 17/12/20.
//

import SwiftUI

struct StatementView: View {
    @ObservedObject var statement: Statement
    @Binding var deleteCount: Int
    @Binding var isEditing: UUID?
    @Binding var selectedProposition: Proposition?
    let editable: Bool
    
    @Binding var newJustificationRequest: JustificationType?
    @Binding var selectedJustificationReferences: [Int]
    
    init(statement: Statement) {
        var d: Int = 0
        let dBinding = Binding<Int>(get: {d}, set: {d = $0})
        
        var ie: UUID? = nil
        let ieBinding = Binding<UUID?>(get: {ie}, set: {ie = $0})
        
        var sp: Proposition? = nil
        let spBinding = Binding<Proposition?>(get: {sp}, set: {sp = $0})
        
        var jr: JustificationType? = nil
        let jrBinding = Binding<JustificationType?>(get: {jr}, set: {jr = $0})
        
        var sjr: [Int] = []
        let sjrBinding = Binding<[Int]>(get: {sjr}, set: {sjr = $0})
        
        self.statement = statement
        self._deleteCount = dBinding
        self._isEditing = ieBinding
        self._selectedProposition = spBinding
        self._newJustificationRequest = jrBinding
        self._selectedJustificationReferences = sjrBinding
        self.editable = false
    }
    
    init(statement: Statement, deleteCount: Binding<Int>, isEditing: Binding<UUID?>, selectedProposition: Binding<Proposition?>, newJustificationRequest: Binding<JustificationType?>, selectedJustificationReferences: Binding<[Int]>, editable: Bool) {
        self.statement = statement
        self._deleteCount = deleteCount
        self._isEditing = isEditing
        self._selectedProposition = selectedProposition
        self._newJustificationRequest = newJustificationRequest
        self._selectedJustificationReferences = selectedJustificationReferences
        self.editable = editable
    }
    
    var color: Color {
        if statement.targeted && editable {
            return Color.init(hue: 1, saturation: 0, brightness: 0.7)
        } else {
            return Color.clear
        }
    }
    
    var body: some View {
        VStack {
            //Text("\(statement.id) content: \(statement.content)").font(.footnote).foregroundColor(Color.red)
            switch statement.type {
            case .conditional:
                junctionStatement
                    .transition(.scale)
                
            case .conjunction:
                junctionStatement
                    .transition(.scale)

            case .disjunction:
                junctionStatement
                    .transition(.scale)
                
            case .negation:
                notStatement
                    .transition(.scale)
                
            default:
                if isEditing == statement.id && editable == true {
                    StatementTextEditor(bindedStatement: statement, deleteTracker: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences)
                        .padding(0)
                        .background(
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 1, height: 25)
                                    .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                                        return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                                    }
                            }
                        )
                } else {
                    Text(statement.content == "" ? "Tap to type..." : statement.content)
                        .transition(.scale)
                        .fixedSize(horizontal: false, vertical: true)
                        .onTapGesture {
                            if editable {
                                isEditing = statement.id
                            }
                        }
                        .allowsHitTesting(editable)
                        .background(
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 1, height: 25)
                                    .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                                        return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                                    }
                            }
                        )
                        //.background(Color.red)
                        
                }
            }
        }
        .accentColor(Color("AccentColor"))
        .foregroundColor(Color("MainText"))
        .background(selectedBackground)
//        .onChange(of: isEditing) { value in
//            print("is editing change detected in view! New is editing id = \(value)")
//        }
//        .onChange(of: statement) { value in
//            print("something")
//        }
    }
    
    var selectedBackground: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .opacity(0.2)
                .frame(width: geometry.frame(in: .local).width + 20, height: geometry.frame(in: .local).height + 20)
                .offset(x: -10, y: -10)
        }
    }
    
    var ifThenStatement: some View {
        //let conditionalBinding = Binding<Conditional>(get: {statement as! Conditional}, set: {statement = $0})
        let conditionalBinding: Conditional  = statement as! Conditional
        let first = conditionalBinding.firstChild
        let second = conditionalBinding.secondChild
        let firstView = StatementView(statement: conditionalBinding.firstChild, deleteCount: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, editable: editable)
        let secondView = StatementView(statement: conditionalBinding.secondChild, deleteCount: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, editable: editable)
            
        return VStack(alignment: .leading, spacing: 4) {
            
            HStack(alignment: .top) {
                
                ZStack(alignment:.topLeading) {
                    Image("if")
                        .foregroundColor(Color.accentColor)
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: first.id, modifier: 0)]
                        }
                        
                    Rectangle()
                        .frame(width: 0, height: 0)
                        .padding(.bottom, 2)
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: second.id, modifier: 0)]
                        }
                }
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                
                firstView
                    .transformAnchorPreference(key: StatementPreferenceKey.self, value: .bounds) { (value, anchor) in
                        value.removeAll()
                    }
            }
            .background(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: geometry.frame(in: .global).width, height: geometry.frame(in: .global).height + 32)
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                        }
                }
            )
            
            HStack(alignment: .top) {
                ZStack(alignment:.bottomLeading) {
                    Image("then")
                        .foregroundColor(Color.accentColor)
                        .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
                        
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
                    .accentColor(deleteCount == 0 ? Color("AccentColor") : Color.red)
            }
        }
    }
    
    var junctionStatement: some View {
        //let conjunctionBinding = Binding<Conjunction>(get: {statement as! Conjunction}, set: {statement = $0})
        let junction = statement as! JunctureStatement
        let firstStatement = junction.firstChild
        let lastStatement = junction.secondChild
        let firstView = StatementView(statement: junction.firstChild, deleteCount: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, editable: editable)
        let secondView = StatementView(statement: junction.secondChild, deleteCount: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, editable: editable)
        
        return HStack {
            if statement.block && firstStatement.block {
                VStack(alignment: .leading, spacing: 4) {
                    firstView
                        .padding(EdgeInsets(top: 0, leading: firstStatement.type == .negation ? 8 : 18, bottom: 0, trailing: 0))
                    HStack {
                        Image(junction.type == .conditional ? "then" : junction.type == .conjunction ? "and" : "or").foregroundColor(Color.accentColor)
                            .fixedSize()
                            .rotationEffect(Angle(degrees: 90))
                            .padding(1)
                            .background(Color.white)
                            .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                                return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                            }
                    }
                    .frame(height: 0)
                    
                    
                    secondView
                        .padding(EdgeInsets(top: 0, leading: lastStatement.type == .negation ? 8 : 18, bottom: 0, trailing: 0))
   
                }
                .backgroundPreferenceValue(StatementPreferenceKey.self) { preferences in
                    GeometryReader { geometry in
                        ConnectiveLines(geometry: geometry, preferences: filterPreferences(firstChild: firstStatement, secondChild: lastStatement, preferences: preferences))
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                    }
                }
            } else {
                if isEditing == statement.id && editable == true {
                    StatementTextEditor(bindedStatement: self.statement, deleteTracker: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences)
                        .padding(0)
                        .background(
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 1, height: 25)
                                    .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                                        return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                                    }
                            }
                        )
                } else {
                    (Text(junction.leftContent)+Text(Image(junction.type == .conditional ? "then" : junction.type == .conjunction ? "and" : "or")).foregroundColor(Color.accentColor)+Text(junction.rightContent))
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.scale)
                        .onTapGesture {
                            if editable {
                                isEditing = statement.id
                            }
                        }
                        .allowsHitTesting(editable)
                        .background(
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 1, height: 25)
                                    .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                                        return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                                    }
                            }
                        )
                }
            }
        }
    }
    
    var andStatement: some View {
        //let conjunctionBinding = Binding<Conjunction>(get: {statement as! Conjunction}, set: {statement = $0})
        let conjunctionBinding = statement as! Conjunction
        let firstStatement = conjunctionBinding.firstChild
        let lastStatement = conjunctionBinding.secondChild
        let firstView = StatementView(statement: conjunctionBinding.firstChild, deleteCount: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, editable: editable)
        let secondView = StatementView(statement: conjunctionBinding.secondChild, deleteCount: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, editable: editable)
        
        return HStack {
            if statement.block && firstStatement.block {
                VStack(alignment: .leading, spacing: 4) {
                    firstView
                        .padding(EdgeInsets(top: 0, leading: firstStatement.type == .negation ? 8 : 18, bottom: 0, trailing: 0))
                    HStack {
                        Image("and").foregroundColor(Color.accentColor)
                            .fixedSize()
                            .padding(1)
                            .background(Color.white)
                            .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                                return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                            }
                    }
                    .frame(height: 0)
                    
                    
                    secondView
                        .padding(EdgeInsets(top: 0, leading: lastStatement.type == .negation ? 8 : 18, bottom: 0, trailing: 0))
   
                }
                .backgroundPreferenceValue(StatementPreferenceKey.self) { preferences in
                    GeometryReader { geometry in
                        ConnectiveLines(geometry: geometry, preferences: filterPreferences(firstChild: firstStatement, secondChild: lastStatement, preferences: preferences))
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                    }
                }
            } else {
                if isEditing == statement.id && editable == true {
                    StatementTextEditor(bindedStatement: self.statement, deleteTracker: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences)
                        .padding(0)
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                        }
                } else {
                    (Text(conjunctionBinding.leftContent)+Text(Image("and")).foregroundColor(Color.accentColor)+Text(conjunctionBinding.rightContent))
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.scale)
                        .onTapGesture {
                            if editable {
                                isEditing = statement.id
                            }
                        }
                        .allowsHitTesting(editable)
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                        }
                }
            }
        }
    }
    
    var orStatement: some View {
        //let disjunctionBinding = Binding<Disjunction>(get: {statement as! Disjunction}, set: {statement = $0})
        let disjunctionBinding = statement as! Disjunction
        let firstStatement = disjunctionBinding.firstChild
        let lastStatement = disjunctionBinding.secondChild
        let firstView = StatementView(statement: disjunctionBinding.firstChild, deleteCount: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, editable: editable)
        let secondView = StatementView(statement: disjunctionBinding.secondChild, deleteCount: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, editable: editable)
        
        return HStack {
            if statement.block && firstStatement.block {
                VStack(alignment: .leading, spacing: 4) {
                    firstView
                        .padding(EdgeInsets(top: 0, leading: firstStatement.type == .negation ? 8 : 18, bottom: 0, trailing: 0))
                        
                    VStack {
                        Image("or").foregroundColor(Color.accentColor)
                            .fixedSize()
                            .padding(1)
                            .background(Color.white)
                            .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                                return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                            }
                    }
                    .frame(height: 0)
                    
                    secondView
                        .padding(EdgeInsets(top: 0, leading: lastStatement.type == .negation ? 8 : 18, bottom: 0, trailing: 0))
   
                }
                .backgroundPreferenceValue(StatementPreferenceKey.self) { preferences in
                    GeometryReader { geometry in
                        ConnectiveLines(geometry: geometry, preferences: filterPreferences(firstChild: firstStatement, secondChild: lastStatement, preferences: preferences))
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                    }
                }
            } else {
                if isEditing == statement.id && editable == true {
                    StatementTextEditor(bindedStatement: self.statement, deleteTracker: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences)
                        .padding(0)
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                        }
                } else {
                    (Text(disjunctionBinding.leftContent)+Text(Image("or")).foregroundColor(Color.accentColor)+Text(disjunctionBinding.rightContent))
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.scale)
                        .onTapGesture {
                            if editable {
                                isEditing = statement.id
                            }
                        }
                        .allowsHitTesting(editable)
                        .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
                            return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
                        }
                }
            }
        }
    }
    
    var notStatement: some View {
        //let negationBinding = Binding<Negation>(get: {statement as! Negation}, set: {statement = $0})
        let negationBinding = statement as! Negation
        let nStatement = negationBinding.negatedStatement
        let nView = StatementView(statement: negationBinding.negatedStatement, deleteCount: $deleteCount, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, editable: editable)
        
        return VStack {
//            if nStatement.block || isEditing != nil {
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
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        //.background(Color.blue)
//            } else {
//                (Text(Image("not")).foregroundColor(Color.accentColor) + Text(nStatement.content))
//                    .fixedSize(horizontal: false, vertical: true)
//                    .anchorPreference(key: StatementPreferenceKey.self, value: .bounds) {
//                        return [StatementPreferenceData(bounds: $0, statementId: statement.id, modifier: 0)]
//                    }
//            }
        }
    }
    
    func positionSymbol(childStatement: Statement, geometry: GeometryProxy, preferences: [StatementPreferenceData]) -> some View {

        ForEach(preferences, id: \.id) { statementPreference in
            if statementPreference.statementId == childStatement.id {
                Image("not")
                    .padding(.bottom, 2)
                    .background(Color.white)
                    .foregroundColor(Color.accentColor)
                    .position(y: geometry[statementPreference.bounds].midY)
                    .offset(x: -10, y: 0)
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
