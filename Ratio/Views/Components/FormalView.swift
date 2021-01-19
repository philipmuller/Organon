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
    
    @State var scrollToIndex: Int?
    @State var scrollPercentage: CGFloat?
    
    //@State var count = 0
    
    let spacing: CGFloat = 20
    
    var body: some View {
        ScrollViewReader { sp in
            LazyVStack(alignment: .leading, spacing: spacing) {
                let somethingSelected = selectedProposition != nil ? true : false
                //Print(formalData.numberOfSteps)
                ForEach(formalData.propositions) { proposition in
                    //Print(index)
                    let selected = selectedProposition?.id == proposition.id ? true : false
                    let faded = !somethingSelected || ((selectedProposition?.justification?.references?.first == proposition.id || selectedProposition?.justification?.references?.last == proposition.id) || selected) ? false : true
                    
                    let propIndex = formalData.propositions.firstIndex(of: proposition) ?? 0
                    let propLevel = formalData.level(of: proposition)
                    
                    PropositionView(proposition: $formalData.propositions[propIndex], selectedProposition: $selectedProposition, editable: $isEditing, draggedIndex: $draggedIndex, draggingCoordinates: $draggingCoordinates, hoverIndex: $scrollToIndex, dragEnded: $dragEnded, onDelete: removeView(for:), level: formalData.level(of: proposition), references: formalData.references(of: proposition), index: propIndex, expanded: selected, faded: faded)
                        .padding(.leading, selected ? 0 : CGFloat(propLevel*20))
                }
            }
//            .backgroundPreferenceValue(PropositionPreferenceKey.self) { preferences in
//                GeometryReader { geometry in
//                    LBracketView(geometry: geometry, preferences: preferences)
//                        .opacity(selectedProposition == nil ? 1 : 0)
//                }
//            }
//            .onPreferenceChange(DestinationDataKey.self) { preferences in
//                for p in preferences {
//                    self.destinations[p.destination] = p.bounds
//                }
//            }
//            .transformAnchorPreference(key: DestinationDataKey.self, value: .bounds) { (value, anchor) in
//                print("HELLLLOOOOO")
//                for v in value {
//                    self.destinations[v.destination] = v.bounds
//                }
//            }
            .id("list")
            .onChange(of: scrollToIndex) { index in
                guard !formalData.propositions.isEmpty else { return }
                guard draggingCoordinates != nil else { return }
                
                //print("Scroll to: \(scrollToIndex)")
                
                formalData.propositions.move(fromOffsets: IndexSet(integer: draggedIndex), toOffset: index!)
                
//                if let uIndex = index {
//                    let displayLength: CGFloat = 844.0
//
//                    let percentage = (100/displayLength)*draggingCoordinates!.y
//
//                    withAnimation(.interpolatingSpring(stiffness: 1, damping: 1)) {
//
//
//                        if percentage < 50  {
//                            let scrollTop = max(uIndex - 1, 0)
//                            sp.scrollTo(formalData.propositions[scrollTop].id)//scrollTo.direction == .up ? .top : .bottom)
//                        } else {
//                            let scrollBottom = min(uIndex + 1, formalData.propositions.count - 1)
//                            sp.scrollTo(formalData.propositions[scrollBottom].id) //anchor: UnitPoint(x: 0, y: index))//scrollTo.direction == .up ? .top : .bottom)
//                        }
//                    }
//                }
                
            }
            
//            .onChange(of: draggingCoordinates) { coordinates in
//                //print(draggingCoordinates)
//                if let uCoordinates = coordinates {
////                    let displayLength: CGFloat = 844.0
////                    let percentage = (100/displayLength)*uCoordinates.y
////
////                    if percentage < 20 || percentage > 80 {
////                        withAnimation(.interpolatingSpring(stiffness: 1, damping: 1)) {
////                            sp.scrollTo(draggedIndex)
////                        }
////                    }
//
//                } else {
//                    //print("Active index: \(draggedIndex)")
//                    sp.scrollTo(formalData.propositions[draggedIndex].id)
//                }
//
//            }
        }
        .animation(.default, value: formalData.propositions)
    }
    
    func removeView(for proposition: Proposition) {
        withAnimation {
            formalData.remove(proposition: proposition)
        }
    }
    
//    func dragMonitor(location: CGPoint?, draggedIndex: Int, finish: Bool) {
//        let displayLength: CGFloat = 844.0
//        if !finish {
//            if let uLocation = location {
//                let percentage = (100/displayLength)*uLocation.y
//                //print("Monitoring position. X: \(uLocation.x), Y: \(uLocation.y), percentage: \(percentage)")
//
//                if uLocation.y < 150 || uLocation.y > (displayLength-150) {
//                    //print("Scroll UP!!")
//                    DispatchQueue.main.async {
//                        scrollPercentage = percentage/100
//                    }
//
//                } else {
//                    DispatchQueue.main.async {
//                        scrollToIndex = draggedIndex
//                        scrollPercentage = nil
//                    }
//                }
//
//                DispatchQueue.main.async {
//                    draggingCoordinates = location
//                    draggedID = formalData.propositions[draggedIndex].id
//                }
//
//
//
////                for (id, upper) in self.upperBounds {
////                    let lower = self.lowerBounds[id] ?? 0
////                    if (uLocation.y > (upper - spacing/2)) && (uLocation.y < (lower + spacing/2)) {
////                        //print("Hovering over: \(id)")
////
////                        if percentage < 50 {
////                            DispatchQueue.main.async {
////                                scrollToIndex = max(0, id-2)
////                            }
////                        } else {
////                            DispatchQueue.main.async {
////                                scrollToIndex = min(formalData.numberOfSteps-1, id+2)
////                            }
////                        }
////
////                        DispatchQueue.main.async {
////                            formalData.propositions.move(fromOffsets: IndexSet(integer: draggedIndex), toOffset: id)
////                        }
////                    }
////                }
//            }
//        } else {
//            //print("ABORT DRAG")
//            scrollToIndex = draggedIndex
//            scrollPercentage = nil
//            DispatchQueue.main.async {
//                draggingCoordinates = nil
//                draggedID = nil
//            }
//        }
//    }
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
