//
//  ArgumentView.swift
//  Ratio
//
//  Created by Philip Müller on 10/11/2020.
//

import SwiftUI

struct ArgumentView: View {
    var title: String
    var argument: Argument
    
    var body: some View {
       // ScrollView{
        
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                
                Text(title)
                    .font(.custom("Silk Serif SemiBold", size: 30))
                    .foregroundColor(Color("MainText"))
                    .padding(.bottom, 15)
                    .padding(.trailing, 80)
                
                Divider()
                
                FormalArgumentView(propositions: argument.propositions)
                    //.padding(EdgeInsets(top: 25, leading: 5, bottom: 25, trailing: 5))
                    //.layoutPriority(1)
                    .font(.custom("AvenirNext-Medium", size: 16))
                    //.background(Color.red)
                
                
                
                Spacer()
            //}.frame(width: geometry.size.width)
            //.padding(EdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 30))
        }
    
    }
            
  }
}


struct ArgumentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let title = "Kalam \nCosmological \nArgument"
        
        let firstPremise = LegacyProposition(type: .premise, text: "Everything that begins to exist has a cause.")
        let secondPremise = LegacyProposition(type: .premise, text: "The universe began to exist.")
        let conclusion = LegacyProposition(type: .conclusion, text: "Therefore, the universe has a cause.")
        
        let propositions = [firstPremise, secondPremise, conclusion]
        
        
        //ArgumentView(title: title, propositions: propositions)
    }
}
