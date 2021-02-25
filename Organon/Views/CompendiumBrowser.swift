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
    let fourthSectionEntries = CompendiumData.generateFourthSection()
    let fifthSectionEntries = CompendiumData.generateFifthSection()
    let sixthSectionEntries = CompendiumData.generateSixthSection()
    let seventhSectionEntries = CompendiumData.generateSeventhSection()
    let eigthSectionEntries = CompendiumData.generateEigthSection()
    
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let imageResouceNames = ["Congiunzioni" : "and", "Disgiunzioni" : "or", "Condizionali" : "then", "Negazioni" : "not"]
    let inferenceIcons: [String : JustificationType] = ["Modus ponens" : .MP, "Modus tollens" : .MT, "Sillogismo disgiuntivo" : .DS, "Sillogismo ipotetico" : .HS, "Addizione" : .AD, "Associazione" : .AS, "Dilemma costruttivo" : .CD, "Commutazioni" : .CM, "Congiunzione" : .CN, "Distribuzione" : .DIST, "Legge di De Morgan" : .DM, "Semplificazioni" : .SM, "Tautologia" : .TAUT, "Trasposizione" : .TRAN, "Implicazione materiale" : .IMP, "Doppia negazione" : .DN, "Esportazione" : .EXP, "Prova condizionale" : .CP, "Dimostrazione per assurdo" : .IP]
    
    @State var showSearchIcon = false
    @State var showTitleInBar = false
    @State var settingsPresented: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                    .background(BackgroundFrameGetter())
                    
                
                section(entries: firstSectionEntries, title: "Le basi")
                section(entries: secondSectionEntries, title: "Tipi di proposizioni")
                section(entries: thirdSectionEntries, title: "Sillogismi")
                section(entries: fourthSectionEntries, title: "Altre inferenze")
                section(entries: fifthSectionEntries, title: "Prove")
                section(entries: sixthSectionEntries, title: "Fallacie")
                section(entries: seventhSectionEntries, title: "Fallacie formali")
                section(entries: eigthSectionEntries, title: "Fallacie informali")
                
                Button("hello") {
                    settingsPresented = true
                }
                
                
                

            }
            
            
            
        }
        .onPreferenceChange(ScrollViewDataKey.self) { values in
            for value in values {
                if value.offset < -17 {
                    showSearchIcon = true
                    showTitleInBar = true
                } else {
                    showSearchIcon = false
                    showTitleInBar = false
                }
                
                //print(scrollOffset)
            }
        }
        
        
        .navigationBarTitle(showTitleInBar ? "Biblioteca" : "")
        //.navigationBarHidden(false)
        .navigationBarItems(leading: searchBtn
                                .accentColor(Color("BoxGrey"))
            ,trailing:
                Button(action: {
                    settingsPresented.toggle()
                }, label: {
                    Image("settings")
                        .font(Font.system(size: 20, weight: .regular))
                        .foregroundColor(Color("BoxGrey"))
                }).sheet(isPresented: $settingsPresented) { SettingsView() }
        )
    }
    
    var searchBtn: some View {
        VStack {
            if showSearchIcon {
                Image("search")
                    .font(Font.system(size: 20, weight: .regular))
                    .foregroundColor(Color("BoxGrey"))
            }
        }
    }
    
    func section(entries: [CompendiumEntry], title: String) -> some View {
        VStack {
            sectionHeader(title)
                .padding(.bottom, 15)
            sectionContent(entries)
        }
        .padding(.horizontal, 34)
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
                    .frame(width: 153, height: 134)
                    .background(
                        GeometryReader { geometry in
                            
                            let color = Color(entry.allExercisesCompleted ? "AccentColor" : "BoxGrey")
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(color.opacity(entry.allExercisesCompleted ? 0.08 : 0.2))
                            
                            if let symbol = imageResouceNames[entry.title] {
                                Image(symbol)
                                    .font(.system(size: 30))
                                    .foregroundColor(color)
                                    .position(x: geometry.size.width-5, y: 0+5)
                                    //.foregroundColor(Color.red)
                            } else if let icon = inferenceIcons[entry.title] {
                                PropositionIcon(explicitColor: color, justification: Justification(type: icon, references: []), propositionType: .step, references: nil, expanded: false)
                                    .font(.system(size: 30))
                                    .position(x: geometry.size.width-5, y: 0+5)
                            }
                            
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
