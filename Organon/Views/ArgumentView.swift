//
//  ArgumentView.swift
//  Ratio
//
//  Created by Philip Müller on 10/11/2020.
//

import SwiftUI

struct ArgumentView: View {
    
    init(argument: Argument) {
        self.argument = argument
        UITextView.appearance().backgroundColor = .clear
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var argument: Argument
    @State var selectedProposition: Proposition? = nil
    @State var editNote = false
    @State var isEditing: Bool = false {
        didSet {
            print("TRIGGEREDDD")
        }
    }
    
    @State var draggingCoordinates: CGPoint?
    @State var previewID: UUID?
    @State var draggedIndex: Int = 0
    
    @State var newProposition: Proposition?
    
    @State var hasCompletedLongPress: Bool = false
    
    @GestureState var buttonDragState = DragState.inactive
    
    @State var count: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.vertical, showsIndicators: true) {
                header
                FormalView(formalData: argument.formalData, selectedProposition: $selectedProposition, isEditing: $isEditing, draggingCoordinates: $draggingCoordinates, draggedIndex: $draggedIndex)
                    .frame(maxWidth: 310)
                    //.background(Color.red)
                    //.offset(x: -15)
                    .accentColor(Color("AccentColor"))
            }
            
            Button(action: {
                
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(Color.accentColor)
                        .frame(width: 55, height: 55)
                        
                    
                    Image(systemName: "plus")
                        .foregroundColor(Color.white)
                }
                .offset(x: buttonDragState.translation.width - 20, y: buttonDragState.translation.height - 20)
                .onChange(of: buttonDragState.isActive) { value in
                    if value == true {
                        newProposition = Proposition()
                        newProposition!.content.setPublishClosure(closure: argument.sLibrary.publishRequest(text:symbol:))
                        newProposition!.content.setPublisherID(id: argument.sLibrary.id)
                        argument.formalData.add(proposition: newProposition!)
                        draggedIndex = argument.formalData.propositions.count - 1
                    }
                }
                .gesture(longPressDrag)
                
                    
            }
//            .padding(0)
//            .opacity(previewCoordinates != nil ? 1 : 0)
//            .position(x: (previewCoordinates?.x ?? 0), y: (previewCoordinates?.y ?? 0))
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 0.7, damping: 1.2, initialVelocity: 0.5).speed(10)) {
                selectedProposition = nil
                isEditing = false
                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                impactHeavy.impactOccurred()
                DispatchQueue.main.async {
                    argument.formalData.rearrange()
                }
            }
        }
        .font(.custom("AvenirNext-Medium", size: 17))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack
            .accentColor(Color("BoxGrey"))
            , trailing:
                HStack {
                    Button(action: {
                        print("Specials tapped!")
                    }) {
                        Image(systemName: "ellipsis")
                            .font(Font.system(size: 23, weight: .light))
                            .rotationEffect(Angle(degrees: 90))
                    }
                    
                    Button(action: {
                        print("Favorites tapped!")
                    }) {
                        Image(systemName: "info.circle")
                            .font(Font.system(size: 23, weight: .light))
                    }
                }
                .accentColor(Color("BoxGrey"))
        )
    }
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            
        }) {
            Image(systemName: "chevron.backward")
                .font(Font.system(size: 23, weight: .light))
            
        }
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                TextEditor(text: $argument.title)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.custom("SabonBold", size: 28))
                    .foregroundColor(Color("MainText"))
                    .background(GeometryReader{ geometry in
                        Text(argument.title == "" ? "Nuovo ragionamento" : "")
                            .lineSpacing(5)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.custom("SabonBold", size: 28))
                            .foregroundColor(Color("BoxGrey"))
                            .frame(alignment: .leading)
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    })
                
                //Divider()
            }
            .padding(.trailing, 30)
            
            TextEditor(text: $argument.description)
                .foregroundColor(Color("MainText"))
                .background(GeometryReader{ geometry in
                    Text(argument.description == "" ? "Tap to add note" : "")
                        .foregroundColor(Color("BoxGrey"))
                        .frame(alignment: .leading)
                        .padding(.top, 8)
                        .padding(.leading, 4)
                })
            
//            Text("SIMPLE STATEMENTS:")
//                .font(.custom("AvenirNext-DemiBold", size: 13))
//                .foregroundColor(Color("BoxGrey"))
        }
        .padding(.leading, 30)
        .padding(.trailing, 30)
        .padding(.bottom, 30)
    }
    
    var longPressDrag: some Gesture {
        let minimumLongPressDuration = 0.5
        return LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: DragGesture(coordinateSpace: .global))
            .updating($buttonDragState) { value, state, transaction in
                switch value {
                // Long press begins.
                case .first(true):
                    state = .pressing
                // Long press confirmed, dragging may begin.
                case .second(true, let drag):
                    state = .dragging(translation: drag?.translation ?? .zero)
                    DispatchQueue.main.async {
                        draggingCoordinates = drag?.location
                        if let uProposition = newProposition {
                            draggedIndex = argument.formalData.index(for: uProposition)
                        }
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
                    withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 0.7, damping: 1.2, initialVelocity: 0.5).speed(10)) {
                        draggingCoordinates = nil
                        selectedProposition = newProposition
                    }
                }
                
                print("ENDED")
            }
    }
    
    
//    var content: some View {
//        return VStack(alignment: .leading, spacing: 5) {
//            if let uPreviewID = previewID {
//                let proposition = argument.formalData.proposition(for: uPreviewID)!
//                let index = argument.formalData.propositions.firstIndex(of: proposition)!
//                StatementView(statement: $argument.formalData.propositions[index].content, deleteCount: $count, editable: false)
//            }
//        }
//    }
    
//    var iconAndNumber: some View {
//        HStack {
//            PropositionIcon(state: false, type: .step, justification: (nil, nil))
//                
//                Text("1.")
//                    .opacity(0.3)
//            }
//        }
    }

extension ScrollView {
    
    public func fixFlickering() -> some View {
        
        return self.fixFlickering { (scrollView) in
            
            return scrollView
        }
    }
    
    public func fixFlickering<T: View>(@ViewBuilder configurator: @escaping (ScrollView<AnyView>) -> T) -> some View {
        
        GeometryReader { geometryWithSafeArea in
            GeometryReader { geometry in
                configurator(
                ScrollView<AnyView>(self.axes, showsIndicators: self.showsIndicators) {
                    AnyView(
                    VStack {
                        self.content
                    }
                    .padding(.top, geometryWithSafeArea.safeAreaInsets.top)
                    .padding(.bottom, geometryWithSafeArea.safeAreaInsets.bottom)
                    .padding(.leading, geometryWithSafeArea.safeAreaInsets.leading)
                    .padding(.trailing, geometryWithSafeArea.safeAreaInsets.trailing)
                    )
                }
                )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct ArgumentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello world!")
    }
}

