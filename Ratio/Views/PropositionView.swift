//
//  PropositionView.swift
//  Ratio
//
//  Created by Philip Müller on 09/11/2020.
//

import SwiftUI

struct PropositionView: View {
    @Binding var proposition: Proposition
    let onDelete: (Proposition) -> ()
    let position: Int
    let level: Int
    let references: [Int]?
    let reordered: Bool
    
    @Namespace var namespace
    
    let expanded: Bool
    let faded: Bool
    let editable: Bool
    
    @State var offX: CGFloat = 0
    @State var count = 0
    
    var body: some View {
        HStack(alignment: .top) {
            Button(action: {
                self.onDelete(proposition)
            }) {
                Image(systemName: "minus.circle")
            }
            
            if !expanded {
                iconAndNumber
            }
            VStack(alignment: .leading) {
                if expanded {
                    iconAndNumber
                }
                content
                    .padding(.top, expanded ? 7 : 0)
            }
        }
        .padding(.all, expanded ? 20 : 0)
        .frame(minWidth: expanded ? 350 : 0, maxWidth: 350, alignment: .leading)
        .background(generateBackground(expanded: expanded))
        .opacity(faded ? 0.2 : 1)
        .opacity(reordered ? 0 : 1)
        .offset(x: offX)
        .gesture(drag)
        
    }
    var opaqueOverlay: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.init(red: 1, green: 1, blue: 1))
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 30)
            .onChanged { value in
                print(value.translation.width)
                self.offX = min(value.translation.width, 80)
            }
            .onEnded { _ in print("ended") }
    }
    
    var content: some View {
        return VStack(alignment: .leading, spacing: 5) {
            StatementView(statement: $proposition.content, deleteCount: $count, editable: editable)
            
            propositionDetailView
                .frame(width: expanded ? nil : 0, height: expanded ? nil : 0)
        }
    }
    
    var propositionDetailView: some View {
        VStack(alignment: .leading){
            Divider()
                .padding(.bottom, 15)
            if let alias = proposition.alias {
                Text("\"" + alias + "\"")
                    .font(.custom("SabonItalic", size: 14))
                    .foregroundColor(Color("MainText"))
                    .opacity(0.8)
                    .padding(.bottom, 8)
            }
            formula
        }
    }
    
    var formula: some View {
        HStack(alignment: .firstTextBaseline) {
            
            Text("FORMULA: ")
                .font(.custom("AvenirNext-Medium", size: 14))
                .foregroundColor(Color("BoxGrey"))
            
            Text(proposition.content.formula).font(.custom("SabonBold", size: 18))
            
        }
    }
    
    var iconAndNumber: some View {
        HStack {
            if expanded {
                Text("\(position).")
                    .matchedGeometryEffect(id: "number", in: namespace)
                    .opacity(0.3)
                    .alignmentGuide(.basePropositionAlignment) { d in
                        -CGFloat(self.level * 30)
                    }
                
                PropositionIcon(state: expanded, type: proposition.type, justification: (proposition.justification, references))
                    .matchedGeometryEffect(id: "icon", in: namespace)
                    .anchorPreference(key: TagPreferenceKey.self, value: .bounds) {
                        return [TagPreferenceData(bounds: $0, proposition: proposition)]
                    }
                
            } else {
                PropositionIcon(state: expanded, type: proposition.type, justification: (proposition.justification, references))
                    .matchedGeometryEffect(id: "icon", in: namespace)
                    .anchorPreference(key: TagPreferenceKey.self, value: .bounds) {
                        return [TagPreferenceData(bounds: $0, proposition: proposition)]
                    }
                
                Text("\(position).")
                    .matchedGeometryEffect(id: "number", in: namespace)
                    .opacity(0.3)
                    .alignmentGuide(.basePropositionAlignment) { d in
                        -CGFloat(self.level * 30)
                    }
            }
            
        }
    }
    
    func generateBackground(expanded: Bool) -> some View {
        return RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.white).opacity(expanded ? 1 : 0)
            .shadow(color: Color("BoxGrey"), radius: expanded ? 10 : 0)
    }
    
}

struct PropositionView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello world!")
    }
}
