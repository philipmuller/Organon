//
//  ArgumentView.swift
//  Ratio
//
//  Created by Philip Müller on 10/11/2020.
//

import SwiftUI
import UniformTypeIdentifiers

struct ArgumentView: View {
    @ObservedObject var argument: Argument
    @State var selectedProposition: Proposition? = nil
    @State var movingID: UUID? = nil
    @State var isEditing: Bool = false
    @State var changedLocation: Bool = false
    
    var body: some View {
        HStack {
            ScrollView {
                header
                FormalView(formalData: $argument.formalData, selectedProposition: $selectedProposition, isEditing: $isEditing, movingID: $movingID, changedLocation: $changedLocation)
                    .frame(maxWidth: 300)
                    .accentColor(Color("AccentColor"))
            }
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .onDrop(of: [UTType.text], delegate: DropOutsideDelegate(currentlyMoving: $movingID, changedLocation: $changedLocation))
            .onTapGesture {
                withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 0.7, damping: 1.2, initialVelocity: 0.5).speed(10)) {
                    selectedProposition = nil
                    isEditing = false
                }
            }
        }
        .animation(.default, value: argument.formalData.propositions)
        .animation(.default, value: movingID)
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
}

struct DropOutsideDelegate: DropDelegate {
    @Binding var currentlyMoving: UUID?
    @Binding var changedLocation: Bool
        
    func performDrop(info: DropInfo) -> Bool {
        currentlyMoving = nil
        changedLocation = false
        return true
    }
}


struct ArgumentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello world!")
    }
}
