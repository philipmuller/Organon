//
//  Bracket.swift
//  Ratio
//
//  Created by Philip Müller on 09/11/2020.
//

import SwiftUI

struct Bracket: Shape {
    let firstLevelPositions: [CGFloat]
    let connectToPosition: CGFloat?
    let firstLevelDepth: CGFloat
    let secondLevelDepth: CGFloat?
    
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: firstLevelPositions[0]))
        
        for yPosition in firstLevelPositions {
            path.addLine(to: CGPoint(x: rect.minX - firstLevelDepth, y: yPosition))
            path.addLine(to: CGPoint(x: rect.minX, y: yPosition))
            path.addLine(to: CGPoint(x: rect.minX - firstLevelDepth, y: yPosition))
        }
        
        //path.closeSubpath()
        
        if let uConnectToPosition = connectToPosition {
            if let uSecondLevelDepth = secondLevelDepth {
                let middle: CGFloat = firstLevelPositions[0] + ((firstLevelPositions[firstLevelPositions.count - 1] - firstLevelPositions[0])/2)
                
                path.move(to: CGPoint(x: rect.minX - firstLevelDepth, y: middle))
                
                path.addLine(to: CGPoint(x: rect.minX - (firstLevelDepth+uSecondLevelDepth), y: middle))
                path.addLine(to: CGPoint(x: rect.minX - (firstLevelDepth+uSecondLevelDepth), y: uConnectToPosition))
                path.addLine(to: CGPoint(x: rect.minX, y: uConnectToPosition))
            }
        }
        
        return path
    }
    
}

struct LBracket: Shape {
    let firstPosition: CGPoint
    let connectToPosition: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: firstPosition)
    
        path.addLine(to: CGPoint(x: connectToPosition.x, y: firstPosition.y))
        
        path.addLine(to: connectToPosition)
        
        return path
    }
    
}

struct Bracket_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Bracket(firstLevelPositions: [0, 40, 80], connectToPosition: 150, firstLevelDepth: 10, secondLevelDepth: 20)
                .stroke()
        }
        .background(Color.blue)
        .frame(width: 100)
    }
}
