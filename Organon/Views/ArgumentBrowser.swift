//
//  ArgumentBrowser.swift
//  Organon
//
//  Created by Philip Müller on 05/02/21.
//

import SwiftUI

struct ArgumentBrowser: View {
    @State var arguments: [Argument]
    @State var hideSearch = true
    @State var selection: UUID? = nil
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                header
                
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(arguments) { argument in
                        VStack {
                            NavigationLink(destination: ArgumentView(argument: argument), tag: argument.id, selection: $selection) {
                                ArgumentPreviewCell(argument: argument)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, -20)
            }
            .navigationBarTitle("")
            //.navigationBarHidden(false)
            .navigationBarItems(leading: searchBtn
                .accentColor(Color("BoxGrey"))
                , trailing:
                    NavigationLink(
                        destination: SettingsView()
                    ) {
                        Image("settings")
                            .font(Font.system(size: 20, weight: .regular))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accentColor(Color("BoxGrey"))
            )
//            NavigationLink(
//                destination: ArgumentView(argument: addNewArgument())
//            ) {
//
//            }
//            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                let argument = Argument(title: "", propositions: [])
                arguments.append(argument)
                selection = argument.id
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(Color.accentColor)
                        .frame(width: 55, height: 55)
                        
                    
                    Image("delete")
                        .font(.system(size: 25, weight: .thin, design: .default))
                        .rotationEffect(Angle(degrees: 45))
                        .foregroundColor(Color.white)
                }
                .offset(x: -20, y: -20)
            }
        }
    }
    
    func addNewArgument() -> Argument {
        let argument = Argument(title: "\(UUID())", propositions: [])
        DispatchQueue.main.async {
            self.arguments.append(argument)
        }
        return argument
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Ragionamenti")
                    .font(.custom("SabonBold", size: 30))
                    .foregroundColor(Color("MainText"))
                    .padding(.leading, 30)
                
                Spacer()
                
                
                
            }
            //.padding(.top, 60)
            .padding(.bottom, 20)
            
            Button(action: {
                print("Favorites tapped!")
            }) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BoxGrey").opacity(0.3))
                        .frame(height: 40)
                    
                    HStack() {
                        Image("search")
                            .font(Font.system(size: 17, weight: .regular))
                            .padding(.leading, 10)
                            .foregroundColor(Color("BoxGrey"))
                        Text("Tocca per cercare")
                            .foregroundColor(Color("BoxGrey"))
                    }
                    
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
                
            }
        }
    }
    
    var searchBtn: some View {
        VStack {
            if !hideSearch {
                Image("search")
                    .font(Font.system(size: 20, weight: .regular))
                    .foregroundColor(Color("BoxGrey"))
            }
        }
    }
}


struct ArgumentPreviewCell: View {
    
    @ObservedObject var argument: Argument
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("2g")
                .foregroundColor(Color("BoxGrey"))
                .padding(.top, 3)
            
            VStack(alignment: .leading) {
                Text(argument.title)
                    .font(.custom("SabonBold", size: 20))
                    .foregroundColor(Color("MainText"))
                    .padding(.bottom, 5)
                
//                Text("CONCLUSIONE:")
//                    .font(.custom("AvenirNext-DemiBold", size: 12))
//                    .foregroundColor(Color("BoxGrey"))
                
                if let conclusion = argument.conclusion {
                    StatementView(statement: conclusion.content)
                        .allowsHitTesting(false)
                        .offset(x: calculateOffset(conclusion.content))
                        .font(.custom("AvenirNext-Medium", size: 17))
                        .foregroundColor(Color("MainText").opacity(0.2))
                        //.opacity(0.8)
                    
//                    Text(conclusion.content.content)
//                        .font(.custom("AvenirNext-Medium", size: 17))
//                        .foregroundColor(Color("MainText").opacity(0.6))
                } else {
                    Text(argument.description)
                        .font(.custom("AvenirNext-Medium", size: 17))
                        .foregroundColor(Color("MainText"))
                        //.opacity(0.8)
                }
                
                Divider()
                    .padding(.top, 12)
                
            }
        }
        .padding(.top, 15)
        
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
            offset = -10
        } else if let cod = forStatement as? JunctureStatement {
            if cod.type != .conditional {
                if cod.firstChild.type != .simple || cod.secondChild.type != .simple {
                    offset = -10
                }
            }
        }
        
        return offset
    }
}
