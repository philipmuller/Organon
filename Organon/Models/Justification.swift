//
//  Justification.swift
//  Ratio
//
//  Created by Philip Müller on 07/12/20.
//

import Foundation

struct Justification: Hashable {
    var type: JustificationType?
    var references: [UUID]?
    
    init(type: JustificationType) {
        self.type = type
        references = nil
    }
    
    init(type: JustificationType, references: [UUID]) {
        self.type = type
        self.references = references
    }
}

enum JustificationType {
    case MP
    case MT
    case SM
    case DS
    case HS
    case CN
    case AD
    case CM
    case DN
    case AS
    case CD
    case DM
    case DIST
    case TRAN
    case IMP
    case EQ
    case EXP
    case TAUT
    case CP
    case ACP
    case IP
    case AIP
    case UI
    case UG
    case EI
    case EG
    case CQ
    
    public func text() -> String {
        switch self {
        case .ACP:
            return "ACP"
        case .AD:
            return "AD"
        case .AIP:
            return "AIP"
        case .AS:
            return "AS"
        case .CD:
            return "CD"
        case .CM:
            return "CM"
        case .CN:
            return "CN"
        case .CP:
            return "CP"
        case .CQ:
            return "CQ"
        case .DIST:
            return "DIST"
        case .DM:
            return "DM"
        case .DN:
            return "DN"
        case .DS:
            return "DS"
        case .EG:
            return "EG"
        case .EI:
            return "EI"
        case .EQ:
            return "EQ"
        case .EXP:
            return "EXP"
        case .HS:
            return "HS"
        case .IMP:
            return "IMP"
        case .IP:
            return "IP"
        case .MP:
            return "MP"
        case .MT:
            return "MT"
        case .SM:
            return "SM"
        case .TAUT:
            return "TAUT"
        case .TRAN:
            return "TRAN"
        case .UG:
            return "UG"
        case .UI:
            return "UI"
            
        default:
            return "Error"
        }
    }
    
    public func extendedText() -> String {
        switch self {
        case .ACP:
            return "Assumption for Conditional Proof"
        case .AD:
            return "Addition"
        case .AIP:
            return "Assumption for Indirect Proof"
        case .AS:
            return "Association"
        case .CD:
            return "Constructive Dilemma"
        case .CM:
            return "Commutation"
        case .CN:
            return "Conjunction"
        case .CP:
            return "Conditional Proof"
        case .CQ:
            return "Change of Quantifier"
        case .DIST:
            return "Distribution"
        case .DM:
            return "DeMorgan’s Rule"
        case .DN:
            return "Double Negation"
        case .DS:
            return "Disjunctive Syllogism"
        case .EG:
            return "Existential Generalisation"
        case .EI:
            return "Existential Instantiation"
        case .EQ:
            return "Material Equivalence"
        case .EXP:
            return "Exportation"
        case .HS:
            return "Hipothetical Syllogism"
        case .IMP:
            return "Material Implication"
        case .IP:
            return "Indirect Proof"
        case .MP:
            return "Modus Ponens"
        case .MT:
            return "Modus Tollens"
        case .SM:
            return "Simplification"
        case .TAUT:
            return "Tautology"
        case .TRAN:
            return "Transposition"
        case .UG:
            return "Universal Generalisation"
        case .UI:
            return "Universal Instantiation"
            
        default:
            return "Error"
        }
    }
    
    public func extendedTextITA() -> String {
        switch self {
        case .ACP:
            return "Supposizione - Prova Condizionale"
        case .AD:
            return "Addizione"
        case .AIP:
            return "Supposizione - Dimostrazione per Assurdo"
        case .AS:
            return "Associazione"
        case .CD:
            return "Dilemma Costruttivo"
        case .CM:
            return "Commutazione"
        case .CN:
            return "Congiunzione"
        case .CP:
            return "Prova Condizionale"
        case .CQ:
            return "-------"
        case .DIST:
            return "Distribuzione"
        case .DM:
            return "Legge di De Morgan"
        case .DN:
            return "Doppia Negazione"
        case .DS:
            return "Sillogismo Disgiuntivo"
        case .EG:
            return "-------"
        case .EI:
            return "-------"
        case .EQ:
            return "Equivalenza Logica"
        case .EXP:
            return "Esportazione"
        case .HS:
            return "Sillogismo Ipotetico"
        case .IMP:
            return "----------"
        case .IP:
            return "Dimostrazione per Assurdo"
        case .MP:
            return "Modus Ponens"
        case .MT:
            return "Modus Tollens"
        case .SM:
            return "Semplificazione"
        case .TAUT:
            return "Tautologia"
        case .TRAN:
            return "Transposizione"
        case .UG:
            return "--------"
        case .UI:
            return "---------"
            
        default:
            return "Error"
        }
    }
    
    public func textITA() -> String {
        switch self {
        case .ACP:
            return "SPC"
        case .AD:
            return "AD"
        case .AIP:
            return "SDA"
        case .AS:
            return "AS"
        case .CD:
            return "DC"
        case .CM:
            return "CM"
        case .CN:
            return "CN"
        case .CP:
            return "PC"
        case .CQ:
            return "CQ"
        case .DIST:
            return "DIST"
        case .DM:
            return "DM"
        case .DN:
            return "DN"
        case .DS:
            return "SD"
        case .EG:
            return "EG"
        case .EI:
            return "EI"
        case .EQ:
            return "EL"
        case .EXP:
            return "ESP"
        case .HS:
            return "SI"
        case .IMP:
            return "IMP"
        case .IP:
            return "DA"
        case .MP:
            return "MP"
        case .MT:
            return "MT"
        case .SM:
            return "SM"
        case .TAUT:
            return "TAUT"
        case .TRAN:
            return "TRAN"
        case .UG:
            return "UG"
        case .UI:
            return "UI"
            
        default:
            return "Error"
        }
    }
}
