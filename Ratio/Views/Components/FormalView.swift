//
//  FormalArgumentView.swift
//  Ratio
//
//  Created by Philip Müller on 07/11/2020.
//

import SwiftUI

struct FormalView: View {
    
    @Binding var formalData: FormalData
    @Binding var selectedProposition: Proposition?
    @Binding var isEditing: Bool
    
    @State var upperBounds: [Int: CGFloat] = [:]
    @State var lowerBounds: [Int: CGFloat] = [:]
    
    @State var draggingCoordinates: CGPoint?
    @State var draggedIndex: Int = 0
    @State var hoverIndex: Int?
    @State var dragEnded: Bool = false
    
    @State var scrollPercentage: CGFloat?
    
    //@State var count = 0
    
    let spacing: CGFloat = 20
    
    var body: some View {
        //ScrollViewReader { sp in
            LazyVStack(alignment: .basePropositionAlignment, spacing: spacing) {
                let somethingSelected = selectedProposition != nil ? true : false
                ForEach(formalData.propositions) { proposition in
                    let selected = selectedProposition?.id == proposition.id ? true : false
                    let faded = !somethingSelected || ((selectedProposition?.justification?.references?.first == proposition.id || selectedProposition?.justification?.references?.last == proposition.id) || selected) ? false : true
                    
                    let propIndex = formalData.propositions.firstIndex(of: proposition) ?? 0
                    let propLevel = formalData.level(of: proposition)
                    
                    PropositionView(proposition: $formalData.propositions[propIndex], selectedProposition: $selectedProposition, editable: $isEditing, draggedIndex: $draggedIndex, draggingCoordinates: $draggingCoordinates, onDelete: removeView(for:), level: formalData.level(of: proposition), references: formalData.references(of: proposition), index: propIndex, expanded: selected, faded: faded)
                        .background(hoverTrigger(index: propIndex))
                        .padding(.leading, selected ? 0 : CGFloat(propLevel*30))
                }
            }
            .onChange(of: hoverIndex) { index in
                guard !formalData.propositions.isEmpty else { return }
                guard draggingCoordinates != nil else { return }
                
                formalData.propositions.move(fromOffsets: IndexSet(integer: draggedIndex), toOffset: index!)
            }
        //}
        .animation(.default, value: formalData.propositions)
    }
    
    func removeView(for proposition: Proposition) {
        withAnimation {
            formalData.remove(proposition: proposition)
        }
    }
    
    func hoverTrigger(index: Int) -> some View {
        GeometryReader { geometry in
           RoundedRectangle(cornerRadius: 10)
            .fill(Color.clear)
            .onChange(of: draggingCoordinates) { value in
                if let uValue = value {
                    if (uValue.y > (geometry.frame(in: .global).minY - 10)) && (uValue.y < (geometry.frame(in: .global).maxY + 10)) {
                        if uValue.y < geometry.frame(in: .global).midY {
                            print("Hovering index \(index)")
                            hoverIndex = index
                        } else {
                            hoverIndex = min(index + 1, formalData.numberOfSteps - 1)
                        }
                    }
                }
            }
        }
    }
}

extension HorizontalAlignment {
    enum BasePropositionAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.leading]
        }
    }
    
    static let basePropositionAlignment = HorizontalAlignment(BasePropositionAlignment.self)
}

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

struct PropositionPreferenceData: Identifiable {
    let id = UUID()
    let bounds: Anchor<CGRect>
    let proposition: Proposition
}

struct PropositionPreferenceKey: PreferenceKey {
    typealias Value = [PropositionPreferenceData]
    
    static var defaultValue: [PropositionPreferenceData] = []
    
    static func reduce(value: inout [PropositionPreferenceData], nextValue: () -> [PropositionPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

//struct BackgroundFrameGetter: View {
//    let destination: Int
//    var body: some View {
//        GeometryReader { geometry in
//           Rectangle()
//            .fill(Color.clear)
//            .preference(key: DestinationDataKey.self, value: [DestinationData(destination: self.destination, min: geometry.frame(in: .global).minY, max: geometry.frame(in: .global).maxY)])
//        }
//    }
//}

struct DestinationDataKey: PreferenceKey {
    typealias Value = [DestinationData]

    static var defaultValue: [DestinationData] = []

    static func reduce(value: inout [DestinationData], nextValue: () -> [DestinationData]) {
        print("LAST TESTT")
        value.append(contentsOf: nextValue())
    }
}

struct DestinationData: Identifiable {
    let id = UUID()
    let bounds: Anchor<CGRect>
    let destination: Int
    //let proxy: GeometryProxy
}



struct FormalArgumentView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Text("Nothing to see here")
        }
    }
}
