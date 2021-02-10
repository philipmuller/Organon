//
//  test.swift
//  Ratio
//
//  Created by Philip Müller on 20/12/20.
//

import SwiftUI

struct StatementTextEditor: View {
    private var placeholder: String
    private var onCommit: (() -> Void)?
    @State private var viewHeight: CGFloat = 40 //start with one line
    @State private var shouldShowPlaceholder = false
    @ObservedObject var statement: Statement
    @Binding var deleteWrapper: Int
    @Binding var isEditing: UUID?
    @Binding var selectedProposition: Proposition?
    @Binding var newJustificationRequest: JustificationType?
    @Binding var selectedJustificationReferences: [Int]
    
//    private var internalStatement: Binding<Statement> {
//        Binding<Statement>(get: { self.statement } ) {
//            self.statement = $0
//        }
//    }
    
    private var internalDeleteCount: Binding<Int> {
        Binding<Int>(get: { self.deleteWrapper } ) {
            self.deleteWrapper = $0
        }
    }

    var body: some View {
        UITextViewWrapper(deleteWrapper: internalDeleteCount, statement: statement, calculatedHeight: $viewHeight, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, onDone: onCommit)
            .frame(minHeight: viewHeight, maxHeight: viewHeight)
            .offset(x: -5, y: -8)
            .background(placeholderView, alignment: .topLeading)
            .padding(0)
//            .onChange(of: statement) { value in
//                print("I am desperate")
//            }
    }

    var placeholderView: some View {
        Group {
            if shouldShowPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
    
    init (bindedStatement: Statement, deleteTracker: Binding<Int>, placeholder: String = "", onCommit: (() -> Void)? = nil, isEditing: Binding<UUID?>, selectedProposition: Binding<Proposition?>, newJustificationRequest: Binding<JustificationType?>, selectedJustificationReferences: Binding<[Int]>) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self.statement = bindedStatement
        self._deleteWrapper = deleteTracker
        self._isEditing = isEditing
        self._selectedProposition = selectedProposition
        self._newJustificationRequest = newJustificationRequest
        self._selectedJustificationReferences = selectedJustificationReferences
    }

}


private struct UITextViewWrapper: UIViewRepresentable {
    //typealias UIViewType = UITextView

    @Binding var deleteWrapper: Int
    @ObservedObject var statement: Statement
    @Binding var calculatedHeight: CGFloat
    @Binding var isEditing: UUID?
    @Binding var selectedProposition: Proposition?
    @Binding var newJustificationRequest: JustificationType?
    @Binding var selectedJustificationReferences: [Int]
    var becomeResponder: Bool = true
    var onDone: (() -> Void)?
    @State var previousJustificationRequestState: JustificationType? = nil
    @State var previousSelectedJustificationReferences: [Int] = []

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont(name: "AvenirNext-Medium", size: 18)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        if onDone != nil {
            textField.returnKeyType = .done
        }
        textField.returnKeyType = UIReturnKeyType.done

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        print("Making view... isEditing = \(isEditing), currentStatement = \(statement.id)")
        //if isEditing == statement.id {
            textField.becomeFirstResponder()
        //}
        
        let statementAttributedString = stringFromStatement(statement)
        statementAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AvenirNext-Medium", size: 18)!, range: NSRange(location: 0, length: statementAttributedString.string.utf16.count))
        statementAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "MainText")!, range: NSRange(location: 0, length: statementAttributedString.string.utf16.count))
        
        textField.attributedText = statementAttributedString
        
        
        
        UITextViewWrapper.recalculateHeight(view: textField, result: $calculatedHeight)
        return textField
    }
    
    func stringFromStatement(_ theStatement: Statement) -> NSMutableAttributedString {
        if let cTheStatement = theStatement as? JunctureStatement {
            let attributedBase = NSMutableAttributedString(string: cTheStatement.leftContent)
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: theStatement.type == .conjunction ? "and" : "or")?.withTintColor(UIColor(Color.accentColor))
            let attachmentS = NSAttributedString(attachment: attachment)
            attributedBase.append(attachmentS)
            attributedBase.append(NSAttributedString(string: cTheStatement.rightContent))
            return attributedBase
        } else {
            return NSMutableAttributedString(string: theStatement.content)
        }
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if previousSelectedJustificationReferences != context.coordinator.selectedJustificationReferences.wrappedValue {
            var text = "@MP "
            print(context.coordinator.selectedJustificationReferences.wrappedValue.debugDescription)
            print(selectedJustificationReferences.debugDescription)
            for reference in selectedJustificationReferences {
                text += "\(reference)"
            }
            uiView.text = text
        }

        print("UPDATE VIEW GOT CALLED")
        if isEditing == statement.id {
            uiView.becomeFirstResponder()
        }
        
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
        
        DispatchQueue.main.async {
            previousJustificationRequestState = context.coordinator.newJustificationRequest.wrappedValue
            previousSelectedJustificationReferences = context.coordinator.selectedJustificationReferences.wrappedValue
        }
    }
    
    static func dismantleUIView(_ uiView: UITextView, coordinator: Coordinator) {
        print("Dismantling Textview!!!")
        uiView.resignFirstResponder()
    }

    private static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // call in next render cycle.
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(deleteWrapper: $deleteWrapper, statement: statement, height: $calculatedHeight, onDone: onDone, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var deleteWrapper: Binding<Int>
        var statement: Statement
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        var liveStatementType: StatementType
        var secondSymbolType: StatementType?
        var isEditing: Binding<UUID?>
        var selectedProposition: Binding<Proposition?>
        var newJustificationRequest: Binding<JustificationType?>
        var selectedJustificationReferences: Binding<[Int]> {
            didSet {
                print("NEW SELECTED JUSTIFICATION: \(selectedJustificationReferences)")
            }
        }
        var shouldStopEditing = true
        var targetingCount = 1
        var justificationEditingMode = false
        
        let typesForTags = [":and" : StatementType.conjunction, ":or" : StatementType.disjunction, ":then" : StatementType.conditional, ":not" : StatementType.negation]
        let tagsForTypes = [StatementType.conjunction : ":and", StatementType.disjunction: ":or", StatementType.conditional : ":then", StatementType.negation : ":not"]
        let imageNames = [StatementType.conjunction : "and", StatementType.disjunction : "or", StatementType.conditional : "then", StatementType.negation : "not"]

        init(deleteWrapper: Binding<Int>, statement: Statement, height: Binding<CGFloat>, onDone: (() -> Void)? = nil, isEditing: Binding<UUID?>, selectedProposition: Binding<Proposition?>, newJustificationRequest: Binding<JustificationType?>, selectedJustificationReferences: Binding<[Int]>) {
            self.deleteWrapper = deleteWrapper
            self.statement = statement
            self.calculatedHeight = height
            self.onDone = onDone
            self.isEditing = isEditing
            self.selectedProposition = selectedProposition
            self.newJustificationRequest = newJustificationRequest
            self.selectedJustificationReferences = selectedJustificationReferences
            self.liveStatementType = statement.type
        }

        func textViewDidChange(_ uiView: UITextView) {
            
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            print("range: \(range), replacementText: \(text)")
            
            //Check if logical operator symbol is about to be deleted
            if let symbolRange = rangeForLogicSymbol(attributedText: textView.attributedText) {
                if range.contains(symbolRange.location) {
                    //this assumes that only 1 symbol can be present at any given point
                    //the symbol is deleted, so we change the statement type to simple
                    liveStatementType = .simple
                    
                }
            }
            
            if let potentialTS = textView.text(in: range.toTextRange(textInput: textView)!) {
                if potentialTS == ":" {
                    targetingCount -= 1
                    statement.targetStatementAtCount(count: targetingCount)
                }
            }
            
            if text == "?" {
                print("content: \(statement.content), formula: \(statement.formula), structure: \(statement.structure)")
            }
            
            if text == ":" {
                let textViewText = textView.text ?? ""
                var currentCharacter = text
                targetingCount = 1
                while currentCharacter == ":" {
                    let lowerBound = max(range.location - targetingCount, 0)
                    let upperBound = min(lowerBound + 1, textViewText.count)
                    currentCharacter = String(textViewText[lowerBound..<upperBound])
                    print(currentCharacter)
                    targetingCount += 1
                }
                targetingCount -= 2
                if let target = statement.target {
                    print("targeting: \(targetingCount)")
                    statement.targetStatementAtCount(count: nil)
                    statement.targetStatementAtCount(count: targetingCount)
                }
            }
            
            //Check if written text is an logical operator tag
            
            if text == " " { //if the new text that wants to be inserted is a space
                //check if the previous characters are a match to the tag:
                let textViewText = textView.text ?? ""
                if textViewText == "@MP" {
                    newJustificationRequest.wrappedValue = JustificationType.MP
                    
                    textView.textColor = UIColor.blue
                    
                    justificationEditingMode = true
                }
                for (tag, statementType) in typesForTags {
                    let lowerBound = max(range.location - tag.count, 0)
                    let upperBound = range.location
                    
                    let potentialTag = textViewText[lowerBound..<upperBound]
                    print(potentialTag)
                    
                    if potentialTag == tag {
                        //we matched a tag! let's create the image and replace the text
                        if statementType == .conjunction || statementType == .disjunction {
                            //on a conjunction or disjunction, we can keep editing in this configuration
                            textView.attributedText = textViewReplacementStringForSybom(oldString: textView.attributedText, currentLocation: range.location, type: statementType)
                            if liveStatementType != .simple {
                                secondSymbolType = statementType
                                shouldStopEditing = false
                                textView.resignFirstResponder()
                            } else {
                                liveStatementType = statementType
                                if targetingCount > 0 {
                                    textView.resignFirstResponder()
                                }
                            }
                        } else {
                            //on anything else, we have to update the entire ui first, to match the writing
                            textView.attributedText = textViewReplacementStringForSybom(oldString: textView.attributedText, currentLocation: range.location, type: statementType)
                            if liveStatementType != .simple {
                                secondSymbolType = statementType
                                shouldStopEditing = false
                                textView.resignFirstResponder()
                            } else {
                                liveStatementType = statementType
                                shouldStopEditing = false
                                textView.resignFirstResponder()
                            }
                            
                        }
                    }
                }
            }
            
            //attempting to delete wrapper:
            if range.location == 0 && text == "" {
                deleteWrapper.wrappedValue += 1
            }
            
            //user is done editing
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            
            
            return true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            print("Text view DID end editing (resigned first responder). about to call update statement. shouldStopEditing \(shouldStopEditing)")
            
            //updateStatement(forText: textView.attributedText, editedType: liveStatementType, secondSymbolType: secondSymbolType)
            save(forText: textView.attributedText)
            print("Back in did end editing! shouldStopEditing is: \(shouldStopEditing)")
            if shouldStopEditing {
                print("Setting isEditing to nil.")
                isEditing.wrappedValue = nil
            }
            print("shouldStopEditing is now true again!")
            //textView.text = "FUCK!"
            print("\(statement.id) is my statement")
            shouldStopEditing = true
            statement.targetStatementAtCount(count: nil)
            targetingCount = 1
        }
        
        func save(forText endText: NSAttributedString) {
            if statement.type == liveStatementType && secondSymbolType == nil {
                if statement.type == .disjunction || statement.type == .conjunction {
                    var junctionWrapper: JunctureStatement {
                        get {
                            self.statement as! JunctureStatement
                        }
                        
                        set {
                            self.statement = newValue
                        }
                    }
                    
                    var cuttingPoint = endText.string.count
                    if let symbolPosition = rangeForLogicSymbol(attributedText: endText)?.location {
                        cuttingPoint = symbolPosition
                    }
                    let lowerBound = 0
                    let upperBound = endText.string.count
                    let simpleTextLeft = String(endText.string[lowerBound..<cuttingPoint])
                    let simpleTextRight = String(endText.string[cuttingPoint..<upperBound])
                    
                    junctionWrapper.firstChild.content = simpleTextLeft
                    junctionWrapper.secondChild.content = simpleTextRight
                    
                } else {
                    statement.content = endText.string
                }
            } else {
                if liveStatementType == .simple {
                    if let uChange = statement.change {
                        uChange(statement.id, Statement(content: endText.string, formula: "A"))
                    }
                } else {
                    var currentStatementTransform = Statement()
                    var splitPieceStatement = Statement(content: "Hahahahahahah", formula: "B")
                    
                    var cuttingPoint = endText.string.count
                    if let symbolPosition = rangeForLogicSymbol(attributedText: endText)?.location {
                        cuttingPoint = symbolPosition
                    }
                    let lowerBound = 0
                    let upperBound = endText.string.count
                    let simpleTextLeft = String(endText.string[lowerBound..<cuttingPoint])
                    let simpleTextRight = String(endText.string[cuttingPoint..<upperBound])
                    currentStatementTransform = Statement(content: simpleTextLeft, formula: "A")
                    splitPieceStatement = Statement(content: simpleTextRight, formula: "B")
                    
                    if secondSymbolType != nil {
                        switch liveStatementType {
                        case .conjunction:
                            currentStatementTransform = Conjunction(currentStatementTransform, splitPieceStatement)
                        case .disjunction:
                            currentStatementTransform = Disjunction(currentStatementTransform, splitPieceStatement)
                        default:
                            print("an error occuredd")
                        }
                        
                        splitPieceStatement = Statement()
                    }
                    
                    self.isEditing.wrappedValue = currentStatementTransform.id
                    if let uChange = statement.change {
                        uChange(statement.id, currentStatementTransform)
                    }
                    currentStatementTransform.delete = statement.delete
                    currentStatementTransform.change = statement.change
                    currentStatementTransform.target = statement.target
                    currentStatementTransform.changeTarget = statement.changeTarget
                    currentStatementTransform.targeted = statement.targeted
                    
                    let type = secondSymbolType != nil ? secondSymbolType! : liveStatementType
                    //self.isEditing.wrappedValue = splitPieceStatement.id
                    
//                    if let uChangeTarget = currentStatementTransform.changeTarget {
//                        uChangeTarget(type, splitPieceStatement)
//                    }
                    self.isEditing.wrappedValue = nil
                    currentStatementTransform.addAtTargeted(connectionType: type, connectTo: splitPieceStatement)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0051) {
                        self.isEditing.wrappedValue = splitPieceStatement.id
                    }
                    print("SPLIT PIECE STATEMENT CONTENT: \(splitPieceStatement)")
                    //currentStatementTransform.target(nil)
                }
            }
        }
        
        func updateTarget(moveHere: Statement) {
            let type = secondSymbolType != nil ? secondSymbolType! : liveStatementType
            self.isEditing.wrappedValue = moveHere.id
            statement.addAtTargeted(connectionType: type, connectTo: moveHere)
        }
        
        func rangeForLogicSymbol(attributedText: NSAttributedString) -> NSRange? {
            let fullTextRange = NSRange(location: 0, length: attributedText.string.utf16.count)
            if attributedText.containsAttachments(in: fullTextRange) {
                var symbolRange: NSRange? = nil
                attributedText.enumerateAttribute(.attachment, in: fullTextRange, options: .longestEffectiveRangeNotRequired) { value, range, bool in
                    
                    if value != nil {
                        symbolRange = range
                    }
                    
                }
                
                return symbolRange
            } else {
                return nil
            }
        }
        
        func attributedStringForSymbol(type: StatementType) -> NSAttributedString {
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: imageNames[type]!)!.withTintColor(UIColor(Color.accentColor))
            return (type == .conditional || type == .negation || liveStatementType != .simple) ? NSAttributedString(string: "") : NSAttributedString(attachment: attachment)
        }
        
        func textViewReplacementStringForSybom(oldString: NSAttributedString, currentLocation: Int, type: StatementType) -> NSAttributedString {
            let newString = NSMutableAttributedString(attributedString: oldString)
            let tagLength = tagsForTypes[type]!.count + targetingCount
            newString.replaceCharacters(in: NSRange(location: currentLocation-tagLength, length: tagLength), with: attributedStringForSymbol(type: type))
            newString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AvenirNext-Medium", size: 18) ?? .boldSystemFont(ofSize: 10), range: NSRange(location: 0, length: newString.string.utf16.count))
            
            return newString
        }
        
        
        
        //func statementFrom(_ attributedString)
    }

}

extension String {
    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }

    subscript (range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }

}

extension NSRange {
    func toTextRange(textInput:UITextInput) -> UITextRange? {
        if let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
            let rangeEnd = textInput.position(from: rangeStart, offset: length) {
            return textInput.textRange(from: rangeStart, to: rangeEnd)
        }
        return nil
    }
}
