//
//  FormalArgumentView.swift
//  Ratio
//
//  Created by Philip Müller on 07/11/2020.
//

import SwiftUI

struct FormalView: View {
    
    @ObservedObject var formalData: FormalData
    @Binding var selectedProposition: Proposition?
    @Binding var isEditing: Bool
    
    @State var upperBounds: [Int: CGFloat] = [:]
    @State var lowerBounds: [Int: CGFloat] = [:]
    
    @Binding var draggingCoordinates: CGPoint?
    @Binding var draggedIndex: Int
    @State var hoverIndex: Int?
    @State var dragEnded: Bool = false
    
    @State var scrollPercentage: CGFloat?
    
    @State var previousIndex: Int = 0
    
    @State var newJustificationRequest: JustificationType?
    @State var selectedJustificationReferences: [Int] = []
    
    //@State var count = 0
    
    let spacing: CGFloat = 20
    
    var body: some View {
        //ScrollViewReader { sp in
            LazyVStack(alignment: .center, spacing: spacing) {
                let somethingSelected = selectedProposition != nil ? true : false
                ForEach(formalData.propositions, id: \.id) { proposition in
                    if !proposition.invisible {
                        let selected = selectedProposition?.id == proposition.id ? true : false
                        
                        let propIndex = formalData.propositions.firstIndex(of: proposition) ?? 0
                        let propLevel = formalData.level(of: proposition)
                        
                        let faded = !somethingSelected || ((selectedProposition?.justification?.references?.first == proposition.id || selectedProposition?.justification?.references?.last == proposition.id) || selected) ? false : true
                        
                        
                        Safe($formalData.propositions, index: propIndex) { binding in
                            PropositionView(proposition: binding.wrappedValue, statement: proposition.content, selectedProposition: $selectedProposition, editable: $isEditing, draggedIndex: $draggedIndex, draggingCoordinates: $draggingCoordinates, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, onDelete: removeView(for:), level: formalData.level(of: proposition), references: formalData.references(of: proposition), index: propIndex, expanded: selected, faded: faded)
                                .background(hoverTrigger(index: propIndex))
                                .padding(.leading, selected ? 0 : CGFloat(propLevel*30))
                        }
                    }
                }
            }
            .onChange(of: hoverIndex) { index in
                guard !formalData.propositions.isEmpty else { return }
                guard draggingCoordinates != nil else { return }
                if previousIndex != index {
                    previousIndex = index!
                    formalData.propositions.move(fromOffsets: IndexSet(integer: draggedIndex), toOffset: index!)
                    //draggedIndex = index!
                    if draggedIndex != index {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
                        impactHeavy.impactOccurred()
                    }
                }
            }
            .onChange(of: newJustificationRequest) { justification in
                if let j = justification, let sp = selectedProposition {
                    //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let terminated = formalData.highlight(justification: j, selectedReferences: selectedJustificationReferences, requestedBy: sp.id)
                        if terminated {
                            newJustificationRequest = nil
                            selectedJustificationReferences = []
                        }
                    //}
                }
            }
            .onChange(of: selectedJustificationReferences) { value in
                if let j = newJustificationRequest, let sp = selectedProposition {
                    //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let terminated = formalData.highlight(justification: j, selectedReferences: selectedJustificationReferences, requestedBy: sp.id)
                        if terminated {
                            newJustificationRequest = nil
                            selectedJustificationReferences = []
                        }
                    //}
                }
            }
        //}
            .animation(draggingCoordinates != nil ? .spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8) : .default, value: formalData.propositions)
    }
    
    func removeView(for proposition: Proposition) {
        DispatchQueue.main.async {
            formalData.remove(proposition: proposition)
        }

    }
    
    func hoverTrigger(index: Int) -> some View {
        GeometryReader { geometry in
           Rectangle()
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

struct BackgroundFrameGetter: View {
    var body: some View {
        GeometryReader { geometry in
           Rectangle()
            .fill(Color.clear)
            .preference(key: ScrollViewDataKey.self, value: [ScrollViewData(offset: geometry.frame(in: .global).minY)])
        }
    }
}

struct ScrollViewDataKey: PreferenceKey {
    typealias Value = [ScrollViewData]

    static var defaultValue: [ScrollViewData] = []

    static func reduce(value: inout [ScrollViewData], nextValue: () -> [ScrollViewData]) {
        value.append(contentsOf: nextValue())
    }
}

struct ScrollViewData: Identifiable, Equatable {
    let id = UUID()
    let offset: CGFloat
    //let proxy: GeometryProxy
}

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
