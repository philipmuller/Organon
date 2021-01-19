//
//  ArgumentView.swift
//  Ratio
//
//  Created by Philip Müller on 10/11/2020.
//

import SwiftUI

struct ArgumentView: View {
    @ObservedObject var argument: Argument
    @State var selectedProposition: Proposition? = nil
    @State var isEditing: Bool = false
    
    @State var previewCoordinates: CGPoint?
    @State var previewID: UUID?
    
    @State var count: Int = 0
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                header
                FormalView(formalData: $argument.formalData, selectedProposition: $selectedProposition, isEditing: $isEditing)
                    .frame(maxWidth: 350)
                    .accentColor(Color("AccentColor"))
            }
            .fixFlickering()
            
            HStack(alignment: .top) {
//                Button(action: {
//
//                }) {
//                    Image(systemName: "minus.circle")
//                }
//
//                iconAndNumber
//                VStack(alignment: .leading) {
//                    content
//                        .padding(0)
//                }
                Text("ksdmom")
            }
            .padding(0)
            .opacity(previewCoordinates != nil ? 1 : 0)
            .position(x: (previewCoordinates?.x ?? 0), y: (previewCoordinates?.y ?? 0))
        }
        .onTapGesture {
            withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 0.7, damping: 1.2, initialVelocity: 0.5).speed(10)) {
                selectedProposition = nil
                isEditing = false
                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                impactHeavy.impactOccurred()
            }
        }
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            Text(argument.title)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
                .font(.custom("SabonBold", size: 30))
                .foregroundColor(Color("MainText"))
                .padding(.bottom, 15)
            
            Divider()
        }
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 80))
        
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


struct ArgumentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello world!")
    }
}
