//
//  Proposition.swift
//  Ratio
//
//  Created by Philip Müller on 07/11/2020.
//

import Foundation

struct LegacyProposition: Identifiable {
    var id = UUID()
    let type: LegacyPropositionType
    let text: String
}


enum LegacyPropositionType {
    case premise
    case conclusion
}
