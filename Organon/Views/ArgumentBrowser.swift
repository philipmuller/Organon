//
//  ArgumentBrowser.swift
//  Organon
//
//  Created by Philip Müller on 05/02/21.
//

import SwiftUI

struct ArgumentBrowser: View {
    var arguments: [Argument]
    var body: some View {
        ScrollView {
            HStack {
                Text("My Arguments")
                    .font(.custom("SabonBold", size: 30))
                    .foregroundColor(Color("MainText"))
                    .padding(.leading, 30)
                Spacer()
            }
            .padding(.top, 60)
            .padding(.bottom, 20)
            
            
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(arguments) { argument in
                    VStack {
                        NavigationLink(
                            destination: ArgumentView(argument: argument)
                        ) {
                            ArgumentPreviewCell(argument: argument)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .frame(width: 380)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct ArgumentPreviewCell: View {
    
    var argument: Argument
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Text("2d")
                .foregroundColor(Color("BoxGrey"))
            
            VStack(alignment: .leading) {
                Text(argument.title)
                    .font(.custom("SabonBold", size: 19))
                    .foregroundColor(Color("MainText"))
                    .padding(.bottom, 5)
                
                Text("CONCLUSIONE:")
                    .font(.custom("AvenirNext-DemiBold", size: 12))
                    .foregroundColor(Color("BoxGrey"))
                
                if let conclusion = argument.conclusion {
                    StatementView(statement: conclusion.content)
                        .allowsHitTesting(false)
                        .offset(x: calculateOffset(conclusion.content))
                        .font(.custom("AvenirNext-Medium", size: 17))
                        .foregroundColor(Color("MainText"))
                        .opacity(0.8)
                } else {
                    Text(argument.description)
                        .font(.custom("AvenirNext-Medium", size: 17))
                        .foregroundColor(Color("MainText"))
                        .opacity(0.8)
                }
                
                Divider()
                    .padding(.top, 15)
                
            }
        }
        .padding(10)
        
        //.frame(width: 350)
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            //.shadow(color: Color("BoxGrey"), radius: 10)
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
}
