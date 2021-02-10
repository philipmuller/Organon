//
//  PropositionView.swift
//  Ratio
//
//  Created by Philip Müller on 09/11/2020.
//

import SwiftUI

struct PropositionView: View {
    @ObservedObject var proposition: Proposition
    @ObservedObject var statement: Statement
    @Binding var selectedProposition: Proposition?
    @Binding var editable: Bool
    
    @Binding var draggedIndex: Int
    @Binding var draggingCoordinates: CGPoint?
    
    @State var swipeAmount: CGFloat = 0
    @State var editedStatementID: UUID?
    
    @Binding var newJustificationRequest: JustificationType?
    @Binding var selectedJustificationReferences: [Int]
    
    let onDelete: (Proposition) -> ()
    
    var  position: Int {
        return index + 1
    }
    let level: Int
    let references: [Int]?
    
    let index: Int
    
    @Namespace var namespace
    
    let expanded: Bool
    let faded: Bool
    
    let swipeTreshhold: CGFloat = 75
    
    @State var swipeHasMetTreshhold: Bool = false
    
    @State var count = 0
    
    @GestureState var dragState = DragState.inactive
    
    var body: some View {
        
        HStack(alignment: .top) {
            
            
            
            if !expanded {
                ZStack(alignment: .center) {
                    iconAndNumber
                        .rotationEffect(Angle(degrees: Double(swipeAmount)), anchor: UnitPoint(x: 0.5, y: 0.5))
                        .opacity(Double(1-(swipeAmount/50)))
                    
                    Button(action: {
                        self.onDelete(proposition)
                    }) {
                        Image(systemName: swipeAmount < swipeTreshhold ? "xmark.circle" : "xmark.circle.fill")
                            .resizable()
                            .frame(width: swipeAmount < swipeTreshhold ? 20 : 25, height: swipeAmount < swipeTreshhold ? 20 : 25)
                            .opacity(Double(swipeAmount/100))
                            .rotationEffect(Angle(degrees: Double(min((-swipeTreshhold + swipeAmount), 0))), anchor: UnitPoint(x: 0.5, y: 0.5))
                            //.scaleEffect(CGSize(width: swipeAmount/100, height: swipeAmount/100))
                            .accentColor(.init(red: 0.8, green: 0.4, blue: 0.4))
                            .onChange(of: swipeAmount) { value in
                                if swipeAmount > swipeTreshhold {
                                    swipeHasMetTreshhold = true
                                } else {
                                    swipeHasMetTreshhold = false
                                }
                            }
                            .onChange(of: swipeHasMetTreshhold) { value in
                                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                impactHeavy.impactOccurred()
                            }
                    }
                    
                }
                .padding(.all, 0)
            }
            VStack(alignment: .leading) {
                if expanded {
                    iconAndNumber
                }
                content
                    .padding(.top, expanded ? 7 : 0)
            }
            
        }
        .padding(.all, expanded ? 20 : 0)
        .frame(minWidth: expanded ? 350 : 0, maxWidth: 350, alignment: .leading)
        .background(background)
        .onChange(of: draggingCoordinates) { value in
            if value == nil && proposition.type == .empty {
                proposition.type = .premise
            }
        }
        .overlay(overlay)
        .opacity((faded && proposition.highlight == false) ? 0.2 : 1)
        .offset(x: swipeAmount)
        .onTapGesture {
            withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 0.7, damping: 1.2, initialVelocity: 0.5).speed(10)) {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
                let impactHeavy = UIImpactFeedbackGenerator(style: .light)
                
                if selectedProposition?.id == proposition.id {
//                    editable = true
//                    print("editable!")
                } else {
                    if newJustificationRequest == nil {
                        selectedProposition = proposition
                        impactHeavy.impactOccurred()
                    } else {
                        if proposition.highlight == true {
                            var isAlreadyPresent = false
                            for reference in selectedJustificationReferences {
                                if reference == index {
                                    isAlreadyPresent = true
                                }
                            }
                            
                            if isAlreadyPresent {
                                selectedJustificationReferences.removeAll(where: { idx in
                                    if idx == index {
                                        return true
                                    } else {
                                        return false
                                    }
                                })
                            } else {
                                selectedJustificationReferences.append(index)
                            }
                            selectedProposition?.type = .step
                            selectedProposition?.justification = Justification(type: newJustificationRequest!, references: [proposition.id])
                            impactHeavy.impactOccurred()
                        }
                    }
                }
            }
        }
        .gesture(ExclusiveGesture(longPressDrag, swipe))
        .animation(.spring(), value: swipeAmount)
        .onAppear() {
            if proposition.type == .empty {
                editedStatementID = proposition.content.id
            }
        }
    }
    
    var content: some View {
        return VStack(alignment: .leading, spacing: 5) {
            StatementView(statement: proposition.content, deleteCount: $count, isEditing: $editedStatementID, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, editable: expanded)
                .offset(x: expanded ? 0 : calculateOffset(proposition.content))
            
            propositionDetailView
                .frame(width: expanded ? nil : 0, height: expanded ? nil : 0)
        }
    }
    
    var propositionDetailView: some View {
        VStack(alignment: .leading){
            Divider()
                .padding(.bottom, 15)
            if let alias = proposition.alias {
                Text("\"" + alias + "\"")
                    .font(.custom("SabonItalic", size: 14))
                    .foregroundColor(Color("MainText").opacity(0.8))
                    .opacity(0.8)
                    .padding(.bottom, 8)
            }
            formula
        }
    }
    
    var formula: some View {
        HStack(alignment: .firstTextBaseline) {
            
            Text("FORMULA: ")
                .font(.custom("AvenirNext-Medium", size: 14))
                .foregroundColor(Color("BoxGrey"))
            
            Text(statement.formula).font(.custom("SabonBold", size: 18))
            
        }
    }
    
    var iconAndNumber: some View {
        HStack {
            if expanded {
                Text("\(position).")
                    .matchedGeometryEffect(id: "\(proposition.id)-number", in: self.namespace)
                    .opacity(0.3)
                    .alignmentGuide(.basePropositionAlignment) { d in
                        -CGFloat(self.level * 30)
                    }
                
                propositionIcon
                    .matchedGeometryEffect(id: "\(proposition.id)-icon", in: self.namespace)
                    .fixedSize(horizontal: true, vertical: false)
                    .anchorPreference(key: PropositionPreferenceKey.self, value: .bounds) {
                        return [PropositionPreferenceData(bounds: $0, proposition: proposition)]
                    }
                
            } else {
                propositionIcon
                    .matchedGeometryEffect(id: "\(proposition.id)-icon", in: self.namespace)
                    .fixedSize(horizontal: true, vertical: false)
                    .anchorPreference(key: PropositionPreferenceKey.self, value: .bounds) {
                        return [PropositionPreferenceData(bounds: $0, proposition: proposition)]
                    }
                    .offset(x: swipeAmount/20)
                
                Text("\(position).")
                    .matchedGeometryEffect(id: "\(proposition.id)-number", in: self.namespace)
                    .opacity(0.3)
                    .alignmentGuide(.basePropositionAlignment) { d in
                        -CGFloat(self.level * 30)
                    }
                    .offset(x: -swipeAmount/20)
            }
            
        }
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(proposition.highlight ? .green : .white)
            .opacity(expanded || dragState.isActive ? 1 : 0.1)
            .shadow(color: Color("BoxGrey"), radius: expanded || dragState.isActive ? 10 : 0)
            .animation(.easeInOut(duration: 0.5), value: dragState.isActive)
    }
    
    func calculateOffset(_ forStatement: Statement) -> CGFloat {
        var offset: CGFloat = 0
        if forStatement.type == .negation {
            offset = -15
        } else if let cod = forStatement as? JunctureStatement {
            if cod.type != .conditional {
                if cod.firstChild.type != .simple || cod.secondChild.type != .simple {
                    offset = -15
                }
            }
        }
        
        return offset
    }
    
    var overlay: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.95))
            .opacity(proposition.type == .empty ? 1 : 0)
    }
    
    var propositionIcon: some View {
        ZStack {
            let lBackground = RoundedRectangle(cornerRadius: 3)
                .foregroundColor(boxColor(type: proposition.type))
    
            Text(justificationText(data: (proposition.justification, references), state: expanded))
                .padding(EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5))
                .background(lBackground)
                .font(.custom("AvenirNext-DemiBold", size: expanded ? 13 : 11))
                .foregroundColor(.white)
        }
    }
    
    func justificationText(data: (Justification?, [Int]?), state: Bool) -> String {
        if let j = data.0 {
            if let r = data.1 {
                if state == true {
                    if let eText = j.type?.extendedText() {
                        return r.count < 2 ? eText + ": \(r.first!)" : eText + ": \(r.first!), \(r.last!)"
                    }
                } else {
                    if let cText = j.type?.text() {
                        return cText
                    }
                }
            }
            if let type = j.type {
                return state ? type.extendedText() : type.text()
            }
        }
        
        return state ? "Premise" : "Pr"
    }
    
    func boxColor(type: PropositionType) -> Color {
        switch type {
        case .conclusion:
            return Color("Conclusion")
        case .premise:
            return Color("Premise")
        case .step:
            return Color("BoxGrey")
        default:
            return Color("BoxGrey")
        }
    }
    
    var swipe: some Gesture {
            DragGesture()
                .onChanged { data in self.swipeAmount = max(800*log10((data.translation.width/700)+1), 0) }
                .onEnded { _ in
                    self.swipeAmount = 0
                    if swipeHasMetTreshhold {
                        self.onDelete(proposition)
                    }
                }
        }
    
    var longPressDrag: some Gesture {
        let minimumLongPressDuration = 0.5
        return LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: DragGesture(coordinateSpace: .global))
            .updating($dragState) { value, state, transaction in
                switch value {
                // Long press begins.
                case .first(true):
                    state = .pressing
                // Long press confirmed, dragging may begin.
                case .second(true, let drag):
                    state = .dragging(translation: drag?.translation ?? .zero)
                    DispatchQueue.main.async {
                        draggingCoordinates = drag?.location
                        draggedIndex = index
                    }
                    
                // Dragging ended or the long press cancelled.
                default:
                    print("Inactive")
                    state = .inactive
                }
                
            }
            .onEnded { value in
                guard case .second(true, let drag?) = value else { return }
                DispatchQueue.main.async {
                    draggingCoordinates = nil
                }
                
                print("ENDED")
            }
    }
    
}

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
        
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
        
    var isActive: Bool {
        switch self {
        case .inactive:
            return false
        case .pressing, .dragging:
            return true
        }
    }
        
    var isDragging: Bool {
        switch self {
        case .inactive, .pressing:
            return false
        case .dragging:
            return true
        }
    }
}

struct Safe<T: RandomAccessCollection & MutableCollection, C: View>: View {
   
   typealias BoundElement = Binding<T.Element>
   private let binding: BoundElement
   private let content: (BoundElement) -> C

   init(_ binding: Binding<T>, index: T.Index, @ViewBuilder content: @escaping (BoundElement) -> C) {
      self.content = content
      self.binding = .init(get: { binding.wrappedValue[index] },
                           set: { binding.wrappedValue[index] = $0 })
   }
   
   var body: some View {
      content(binding)
   }
}

struct PropositionView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello world!")
    }
}
