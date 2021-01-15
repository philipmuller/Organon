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
    
    var body: some View {
        ScrollView {
            header
            FormalView(propositions: $argument.propositions, selectedProposition: $selectedProposition, isEditing: $isEditing)
                .frame(maxWidth: 300)
                .accentColor(Color("AccentColor"))
        }
        .onTapGesture {
            withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 0.7, damping: 1.2, initialVelocity: 0.5).speed(10)) {
                selectedProposition = nil
                isEditing = false
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
}


struct ArgumentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello world!")
    }
}
