//
//  BracketView.swift
//  Ratio
//
//  Created by Philip Müller on 09/11/2020.
//

import SwiftUI

//struct BracketView: View {
//    let geometry: GeometryProxy
//    let preferences: [PropositionPreferenceData]
//
//    var body: some View {
//
//        var premiseYValues: [CGFloat] = []
//        var conclusionYValue: CGFloat = 0
//
//        let depthValues: [CGFloat] = preferences.count < 4 ? [0, 21] : [5, 10]
//
//        for anchor in preferences {
//            if anchor.type == .premise {
//                premiseYValues.append(geometry[anchor.bounds].minY)
//            } else {
//                conclusionYValue = geometry[anchor.bounds].minY
//            }
//        }
//
//        return AnyView(Bracket(firstLevelPositions: premiseYValues, connectToPosition: conclusionYValue, firstLevelDepth: depthValues[0], secondLevelDepth: depthValues[1]).stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 4], dashPhase: 2)).foregroundColor(.gray))
//    }
//}

struct LBracketView: View {
    let geometry: GeometryProxy
    let preferences: [PropositionPreferenceData]
    
    var body: some View {
        let identifiablePointData = generatePointsFromData(geometry: geometry, data: preferences)
        HStack{
            ForEach(identifiablePointData) { data in
    //            Text("\(data.firstPoint.x)")
    //                .font(.title)
                LBracket(firstPosition: data.firstPoint, connectToPosition: data.toPoint)
                    //.stroke(style: StrokeStyle(lineWidth: 0.5, lineCap: .round, lineJoin: .round, dash: [1, 5]))
                    //.stroke(Color("BoxGrey"))
            }
        }
        
    }
    
    func generatePointsFromData(geometry: GeometryProxy, data: [PropositionPreferenceData]) -> [ForBracketData] {
        var startingPoints: [CGPoint] = []
        var endPoints: [CGPoint] = []
        
        for anchor in preferences {
            if let jt = anchor.proposition.justification?.type {
                if jt == .ACP || jt == .AIP {
                    startingPoints.append(CGPoint(x: geometry[anchor.bounds].minX, y: geometry[anchor.bounds].midY))
                }
                
                if jt == .CP || jt == .IP {
                    endPoints.append(CGPoint(x: geometry[anchor.bounds].midX, y: geometry[anchor.bounds].minY))
                }
            }
        }
        
        endPoints.reverse()
        
        var finalData: [ForBracketData] = []
        var count = 0
        for point in endPoints {
            var sp: CGPoint = CGPoint(x: point.x, y: 0)
            if count < startingPoints.count {
                sp = startingPoints[count]
            }
            finalData.append(ForBracketData(firstPoint: sp, toPoint: point))
            count += 1
        }
        
        return finalData
    }
}

struct ForBracketData: Identifiable {
    let id = UUID()
    let firstPoint: CGPoint
    let toPoint: CGPoint
}

