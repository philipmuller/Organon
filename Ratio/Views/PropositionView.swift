//
//  PropositionView.swift
//  Ratio
//
//  Created by Philip Müller on 09/11/2020.
//

import SwiftUI

struct PropositionView: View {
    @Binding var proposition: Proposition
    @Binding var selectedProposition: Proposition?
    @Binding var editable: Bool
    
    @Binding var draggedIndex: Int
    @Binding var draggingCoordinates: CGPoint?
    @Binding var hoverIndex: Int?
    @Binding var dragEnded: Bool
    
    let onDelete: (Proposition) -> ()
    //let gestureDrag: (CGPoint?, Int, Bool) -> Void
    
    var  position: Int {
        return index + 1
    }
    let level: Int
    let references: [Int]?
    
    let index: Int
    
    @Namespace var namespace
    
    let expanded: Bool
    let faded: Bool
    
    @State var count = 0
    
    @GestureState var dragState = DragState.inactive
    @State var start = false
    
    @State var isVisible = false
    
    var body: some View {
        
        HStack(alignment: .top) {
            Button(action: {
                self.onDelete(proposition)
            }) {
                Image(systemName: "minus.circle")
            }
            
            if !expanded {
                iconAndNumber
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
        //.coordinateSpace(name: "test")
        //.position(x: dragState.translation.x, y: dragState.translation.y)
//        .anchorPreference(key: DestinationDataKey.self, value: .bounds) {
//            print("HIIIIIIIIIIIIII")
//            return [DestinationData(bounds: $0, destination: index)]
//        }
//        .onChange(of: draggingCoordinates) { value in
//            targets[index] = gp.frame(in: .global)
//        }
        .background(background)
        .opacity(faded ? 0.2 : 1)
        //.overlay(start ? RoundedRectangle(cornerRadius: 5).fill(Color(hue: 1, saturation: 0, brightness: 0.95)) : nil)
        .onTapGesture {
            withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 0.7, damping: 1.2, initialVelocity: 0.5).speed(10)) {
                print("Selected proposition id: \(selectedProposition?.id), proposition id: \(proposition.id)")
                if selectedProposition?.id == proposition.id {
                    editable = true
                    print("editable!")
                } else {
                    selectedProposition = proposition
                    editable = false
                    let impactHeavy = UIImpactFeedbackGenerator(style: .light)
                    impactHeavy.impactOccurred()
                }
            }
        }
        .gesture(longPressDrag)
    }
    
    var content: some View {
        return VStack(alignment: .leading, spacing: 5) {
            StatementView(statement: $proposition.content, deleteCount: $count, editable: editable)
            
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
                    .foregroundColor(Color("MainText"))
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
            
            Text(proposition.content.formula).font(.custom("SabonBold", size: 18))
            
        }
    }
    
    var iconAndNumber: some View {
        HStack {
            if expanded {
                Text("\(position).")
                    .matchedGeometryEffect(id: "\(proposition.id)-number", in: namespace)
                    .opacity(0.3)
                    .alignmentGuide(.basePropositionAlignment) { d in
                        -CGFloat(self.level * 30)
                    }
                
                PropositionIcon(state: expanded, type: proposition.type, justification: (proposition.justification, references))
                    .matchedGeometryEffect(id: "\(proposition.id)-icon", in: namespace)
                    .anchorPreference(key: PropositionPreferenceKey.self, value: .bounds) {
                        return [PropositionPreferenceData(bounds: $0, proposition: proposition)]
                    }
                
            } else {
                PropositionIcon(state: expanded, type: proposition.type, justification: (proposition.justification, references))
                    .matchedGeometryEffect(id: "\(proposition.id)-icon", in: namespace)
                    .anchorPreference(key: PropositionPreferenceKey.self, value: .bounds) {
                        return [PropositionPreferenceData(bounds: $0, proposition: proposition)]
                    }
                
                Text("\(position).")
                    .matchedGeometryEffect(id: "\(proposition.id)-number", in: namespace)
                    .opacity(0.3)
                    .alignmentGuide(.basePropositionAlignment) { d in
                        -CGFloat(self.level * 30)
                    }
            }
            
        }
    }
    
    var background: some View {
        GeometryReader { geometry in
            //Print("HELLLLLOOO")
           RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.white)
            .offset(x: dragState.isActive ? -5 : 0, y: dragState.isActive ? -5 : 0)
            .frame(width: geometry.frame(in: .local).width + (dragState.isActive ? 10 : 0), height: geometry.frame(in: .local).height + (dragState.isActive ? 10 : 0))
            .opacity(expanded || dragState.isActive ? 1 : 0)
            .shadow(color: Color("BoxGrey"), radius: dragState.isActive || expanded ? 10 : 0)
            .animation(.easeIn(duration: 0.5), value: dragState.isActive)
            .onChange(of: draggingCoordinates) { value in
                if let uValue = value {
                    if (uValue.y > (geometry.frame(in: .global).minY-10)) && (uValue.y < (geometry.frame(in: .global).maxY+10)) {
                        hoverIndex = index
                    }
                }
            }
            //Print("source: \(index) minY: \(geometry.frame(in: .global).midY) maxY: \(geometry.frame(in: .global).maxY)")
            //.preference(key: DestinationDataKey.self, value: [DestinationData(destination: index, min: geometry.frame(in: .global).minY, max: geometry.frame(in: .global).maxY)])
        }
    }
    
    var longPressDrag: some Gesture {
        let minimumLongPressDuration = 0.5
        return LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: DragGesture(coordinateSpace: .global))
            .updating($dragState) { value, state, transaction in
                if state.isActive {
                    DispatchQueue.main.async {
                        start = true
                    }
                } else {
                    DispatchQueue.main.async {
                        start = false
                    }
                }
                
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
                        dragEnded = false
                    }
                    
                // Dragging ended or the long press cancelled.
                default:
                    print("Inactive")
                    state = .inactive
                }
                
            }
            .onEnded { value in
                guard case .second(true, let drag?) = value else { return }
                //gestureDrag(nil, index, true)
                draggingCoordinates = nil
                dragEnded = true
                DispatchQueue.main.async {
                    start = false
                }
                print("ENDED")
                
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
    
}

enum RearrangeState {
    case ended, ongoing
}

struct PropositionView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello world!")
    }
}
