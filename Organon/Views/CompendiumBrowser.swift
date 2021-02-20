//
//  CompendiumBrowser.swift
//  Organon
//
//  Created by Philip Müller on 06/02/21.
//

import SwiftUI

struct CompendiumBrowser: View {
    let firstSectionEntries = CompendiumData.generateFirstSection()
    let secondSectionEntries = CompendiumData.generateSecondSection()
    let thirdSectionEntries = CompendiumData.generateThirdSection()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let imageResouceNames = ["Congiunzioni" : "and", "Disgiunzioni" : "or", "Condizionali" : "then", "Negazioni" : "not"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                
                section(entries: firstSectionEntries, title: "Le basi")
                section(entries: secondSectionEntries, title: "Frasi")
                section(entries: thirdSectionEntries, title: "Sillogismi")

            }
            
            
        }
        .navigationBarTitle("")
        //.navigationBarHidden(false)
        .navigationBarItems(trailing:
                NavigationLink(
                    destination: SettingsView()
                ) {
                    Image("settings")
                        .font(Font.system(size: 20, weight: .regular))
                }
                .buttonStyle(PlainButtonStyle())
                .accentColor(Color("BoxGrey"))
        )
    }
    
    func section(entries: [CompendiumEntry], title: String) -> some View {
        VStack {
            sectionHeader(title)
                .padding(.bottom, 15)
            sectionContent(entries)
        }
        .padding(.horizontal, 36)
        .padding(.bottom, 30)
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Biblioteca")
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
    
    func sectionHeader(_ title: String) -> some View {
        
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("SabonBold", size: 20))
            
            Divider()
        }
        
    }
    
    
    func sectionContent(_ entries: [CompendiumEntry]) -> some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(entries) { entry in
                NavigationLink(
                    destination: CompendiumDetail(data: entry)
                ) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(entry.title)
                            .font(.custom("AvenirNext-Medium", size: 17))
                            .foregroundColor(Color("MainText"))
                            
                            //.layoutPriority(1)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(entry.tldr)
                            .font(.custom("AvenirNext-Medium", size: 13))
                            .truncationMode(Text.TruncationMode.tail)
                            .foregroundColor(Color("MainText").opacity(0.8))
                            //.layoutPriority(1)
                        
                        //Spacer()
                            //.layoutPriority(0)
                    }
                    
                    .padding(17)
                    .frame(width: 150, height: 134)
                    .background(
                        GeometryReader { geometry in
                            
                            let color = Color(entry.allExercisesCompleted ? "AccentColor" : "BoxGrey")
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(color.opacity(entry.allExercisesCompleted ? 0.08 : 0.2))
                            
                            Image(imageResouceNames[entry.title] ?? "")
                                .font(.system(size: 30))
                                .foregroundColor(color)
                                .position(x: geometry.size.width-5, y: 0+5)
                                //.foregroundColor(Color.red)
                        }
                        
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
    }
    
}

extension HorizontalAlignment {
    struct CompendiumBubbleVerticalLeft: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[HorizontalAlignment.center]
        }
    }

    static let compendiumBubbleVerticalLeft = HorizontalAlignment(CompendiumBubbleVerticalLeft.self)
    
    struct CompendiumBubbleVerticalRight: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[HorizontalAlignment.compendiumBubbleVerticalLeft]
        }
    }

    static let compendiumBubbleVerticalRight = HorizontalAlignment(CompendiumBubbleVerticalRight.self)
}

struct CompendiumBrowser_Previews: PreviewProvider {
    static var previews: some View {
        CompendiumBrowser()
    }
}
