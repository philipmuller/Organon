//
//  ModalExportOptions.swift
//  Organon
//
//  Created by Philip Müller on 21/02/21.
//

import SwiftUI

enum ExportOption {
    case jpg, web, pdf, text
}

struct ModalExportOptions: View {
    
    @Binding var show: Bool
    
    @State var esportaDescrizione: Bool = true
    @State var classicSymbols: Bool = false
    @State var versioneSimbolica: Bool = false
    
    @State var exportOption: ExportOption = .web
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
//                Text("Condividi")
//                    .font(.custom("SabonBold", size: 20))
//                    .padding(.bottom, 20)
                
                HStack(spacing: 15) {
                    let imageDimension: CGFloat = 55
                    VStack {
                        Image(exportOption == .jpg ? "imageG" : "image")
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageDimension, height: imageDimension)
                        
                        Text("jpg")
                            .font(.custom("AvenirNext-Medium", size: 17))
                            .foregroundColor(exportOption == .jpg ? Color("MainText") : Color("BoxGrey"))
                    }
                    .onTapGesture() {
                        exportOption = .jpg
                    }
                    
                    VStack {
                        Image(exportOption == .web ? "webG" : "web")
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageDimension, height: imageDimension)
                        
                        Text("web")
                            .font(.custom("AvenirNext-Medium", size: 17))
                            .foregroundColor(exportOption == .web ? Color("MainText") : Color("BoxGrey"))
                    }
                    .onTapGesture() {
                        exportOption = .web
                    }
                    
                    VStack {
                        Image(exportOption == .pdf ? "pdfG" : "pdf")
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageDimension, height: imageDimension)
                        
                        Text("pdf")
                            .font(.custom("AvenirNext-Medium", size: 17))
                            .foregroundColor(exportOption == .pdf ? Color("MainText") : Color("BoxGrey"))
                    }
                    .onTapGesture() {
                        exportOption = .pdf
                    }
                    
                    VStack {
                        Image(exportOption == .text ? "textG" : "text")
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageDimension, height: imageDimension)
                        
                        Text("testo")
                            .font(.custom("AvenirNext-Medium", size: 17))
                            .foregroundColor(exportOption == .text ? Color("MainText") : Color("BoxGrey"))
                            
                    }
                    .onTapGesture() {
                        exportOption = .text
                    }
                }
                .padding(.top, 20)
                
                VStack {
                    HStack(spacing: 0) {
                        Text("Esporta descrizione")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.custom("AvenirNext-Medium", size: 17))
                            .foregroundColor(esportaDescrizione ? Color("MainText") : Color("BoxGrey"))
                            .lineLimit(1)
                            
                        
                        Toggle("", isOn: $esportaDescrizione)
                            .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                    }
                    
                    Divider()
                    
                    HStack(spacing: 0) {
                        Text("Simboli classici")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.custom("AvenirNext-Medium", size: 17))
                            .foregroundColor(classicSymbols ? Color("MainText") : Color("BoxGrey"))
                            .lineLimit(1)
                            
                        
                        Toggle("", isOn: $classicSymbols)
                            .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                            
                    }
                    
                    Divider()
                    
                    HStack(spacing: 0) {
                        Text("Versione simbolica")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.custom("AvenirNext-Medium", size: 17))
                            .foregroundColor(versioneSimbolica ? Color("MainText") : Color("BoxGrey"))
                            .lineLimit(1)
                            
                        
                        Toggle("", isOn: $versioneSimbolica)
                            .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                            
                    }
                }
                .padding(.top, 20)
                
                Button(action: shareSheet) {
                    Text("Condividi")
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10)
                        .foregroundColor(Color.white)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.accentColor.opacity(0.8))
                        )
                }
                .padding(.top, 20)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            )
            .padding(.horizontal, 30)
            .padding(.top, 250)
            .padding(.bottom, 100)
            .offset(y: show ? 0 : 400)
            .font(.custom("AvenirNext-Medium", size: 17))
            .foregroundColor(Color("MainText"))
                
        }
        .background(Color.gray.opacity(0.5).onTapGesture {
            self.show = false
        })
        .ignoresSafeArea(.all)
        .opacity(show ? 1 : 0)
        .transition(.offset(x: 0, y: -250))
        .animation(.default)
    }
    
    func shareSheet() {
        show = false
        guard let data = URL(string: "https://www.apple.com") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        
    }
}
