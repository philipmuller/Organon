//
//  ConnectiveLines.swift
//  Ratio
//
//  Created by Philip Müller on 09/12/20.
//

import SwiftUI

struct ConnectiveLines: View {
    let geometry: GeometryProxy
    let preferences: [StatementPreferenceData]
    var depth: Int = 5
    
    var body: some View {
        
        var yValues: [CGFloat] = []
        
        let depthValue: CGFloat = CGFloat(depth)
        
        for anchor in preferences {
            yValues.append(geometry[anchor.bounds].midY+CGFloat(anchor.modifier))
        }

        return AnyView(Bracket(firstLevelPositions: yValues, connectToPosition: nil, firstLevelDepth: depthValue, secondLevelDepth: nil).stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)).foregroundColor(Color.accentColor))
    }
}
