//
//  SettingsView.swift
//  Organon
//
//  Created by Philip Müller on 15/02/21.
//

import SwiftUI

struct SettingsView: View {
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().backgroundColor = .clear
    }
    
    @State var hf = true
    @State var spotlight = true
    @State var highlightCompletedSections = true
    
    @State private var selectedFrameworkIndex = 0
    
    @State var fontTitoloSelezionata: String = "Sabon"
    let fontTitoli = ["Avenir Next", "Helvetica", "Sabon", "Biancoenero", "San Francisco"]
    
    @State var fontTestoSelezionata: String = "Avenir Next"
    let fontTesti = ["Avenir Next", "Helvetica", "Sabon", "Biancoenero", "San Francisco"]
    
    @State var ordineRagionamentiSelezionato: String = "Data"
    let ordineRagionamenti = ["Data", "Alfabetico"]
    
    @State var ordineArticoliSelezionato: String = "Complessità"
    let ordineArticoli = ["Alfabetico", "Complessità", "Completati"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                Text("Impostazioni")
                    .font(.custom("SabonBold", size: 28))
                    .foregroundColor(Color("MainText"))
                    .padding(.top, 40)
                    .padding(.leading, 30)
                
                Form {
                    
                    generalSection
                    
                    sharingSection
                    
                    argumentsSection
                    
                    librarySection
                    
                }
                .navigationBarHidden(true)
                .listStyle(PlainListStyle())
                .font(.custom("AvenirNext-Medium", size: 17))
                .foregroundColor(Color("MainText").opacity(0.8))
            }
            .padding(.horizontal, 2)
        }
        
        
        
    }
    
    var generalSection: some View {
        Section(header: HStack {
            Text("Generali")
                .font(.custom("SabonBold", size: 20))
                .foregroundColor(Color("MainText"))
                .padding()

                Spacer()
        }
        .background(Color.white)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))) {
            HStack {
                Text("Haptic feedback")
                Spacer()
                Toggle("", isOn: $hf)
                    .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
            }
            Section {
                Picker(selection: $fontTitoloSelezionata, label: Text("Font titoli")) {
                    ForEach(fontTitoli, id: \.self) { font in
                        Text(font)
                    }
                }
                
                    
                Picker(selection: $fontTestoSelezionata, label: Text("Font testi")) {
                    ForEach(fontTesti, id: \.self) { font in
                        Text(font)
                    }
                }
                
            }
            
            
//            NavigationLink(destination: Text("Hello haha")) {
//                Text("Tipografia")
//            }
            .id(UUID())
            .buttonStyle(PlainButtonStyle())
            
            NavigationLink(destination: ColorThemeView()) {
                Text("Temi e colori")
            }
            .id(UUID())
            .buttonStyle(PlainButtonStyle())
            
            HStack {
                Text("Trova con spotlight")
                Spacer()
                Toggle("", isOn: $spotlight)
                    .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
            }
            
            NavigationLink(destination: Text("Hello haha")) {
                Text("Accessibilità")
            }
            .id(UUID())
            .buttonStyle(PlainButtonStyle())
            
        }
        .textCase(nil)
    }
    
    var sharingSection: some View {
        Section(header: HStack {
            Text("Condivisione")
                .font(.custom("SabonBold", size: 20))
                .foregroundColor(Color("MainText"))
                .padding()

                Spacer()
        }
        .background(Color.white)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))) {
            
            NavigationLink(destination: Text("Hello haha")) {
                Text("Predefiniti")
            }
            .id(UUID())
            .buttonStyle(PlainButtonStyle())
            NavigationLink(destination: Text("Hello haha")) {
                Text("Condivisione web")
            }
            .id(UUID())
            .buttonStyle(PlainButtonStyle())
            
        }
        .textCase(nil)
    }
    
    var argumentsSection: some View {
        Section(header: HStack {
            Text("Ragionamenti")
                .font(.custom("SabonBold", size: 20))
                .foregroundColor(Color("MainText"))
                .padding()

                Spacer()
        }
        .background(Color.white)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))) {
            
            Section {
                Picker(selection: $ordineRagionamentiSelezionato, label: Text("Ordina per")) {
                    ForEach(ordineRagionamenti, id: \.self) { ordine in
                        Text(ordine)
                    }
                }
            }
            
            Text("Importa ragionamenti")
            Text("Esegui backup")
            Text("Ripristina da backup")
        }
        .textCase(nil)
    }
    
    var librarySection: some View {
        Section(header: HStack {
            Text("Biblioteca")
                .font(.custom("SabonBold", size: 20))
                .foregroundColor(Color("MainText"))
                .padding()

                Spacer()
        }
        .background(Color.white)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))) {
            Section {
                Picker(selection: $ordineArticoliSelezionato, label: Text("Ordina per")) {
                    ForEach(ordineArticoli, id: \.self) { ordine in
                        Text(ordine)
                    }
                }
            }
            
            HStack {
                Text("Evidenzia sezioni completate")
                Spacer()
                Toggle("", isOn: $highlightCompletedSections)
                    .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
            }
            
            NavigationLink(destination: Text("Hello haha")) {
                Text("Notifiche esercitazione")
            }
            .buttonStyle(PlainButtonStyle())
            .id(UUID())
            
        }
        .textCase(nil)
    }
}

struct CustomHeader: View {
    let name: String
    let color: Color

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(name)
                Spacer()
            }
            Spacer()
        }
        .padding(0).background(FillAll(color: color))
    }
}

struct FillAll: View {
    let color: Color
    
    var body: some View {
        GeometryReader { proxy in
            self.color.frame(width: proxy.size.width * 1.3).fixedSize()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
