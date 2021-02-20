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
    let forceBranching: Bool
    
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
        UITextViewWrapper(deleteWrapper: internalDeleteCount, statement: statement, calculatedHeight: $viewHeight, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, onDone: onCommit, forceBranching: forceBranching)
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
    
    init (bindedStatement: Statement, deleteTracker: Binding<Int>, placeholder: String = "", onCommit: (() -> Void)? = nil, isEditing: Binding<UUID?>, selectedProposition: Binding<Proposition?>, newJustificationRequest: Binding<JustificationType?>, selectedJustificationReferences: Binding<[Int]>, forceBranching: Bool) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self.statement = bindedStatement
        self._deleteWrapper = deleteTracker
        self._isEditing = isEditing
        self._selectedProposition = selectedProposition
        self._newJustificationRequest = newJustificationRequest
        self._selectedJustificationReferences = selectedJustificationReferences
        self.forceBranching = forceBranching
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
    let forceBranching: Bool

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont(name: "AvenirNext-Medium", size: 17)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        if onDone != nil {
            textField.returnKeyType = .done
        }
        textField.returnKeyType = UIReturnKeyType.done
        
        let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: nil)
        bar.items = [reset, reset, reset]
        bar.sizeToFit()
        textField.inputAccessoryView = bar

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        print("Making view... isEditing = \(isEditing), currentStatement = \(statement.id)")
        //if isEditing == statement.id {
            textField.becomeFirstResponder()
        //}
        
        let statementAttributedString = stringFromStatement(statement)
        statementAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AvenirNext-Medium", size: 17)!, range: NSRange(location: 0, length: statementAttributedString.string.utf16.count))
        statementAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "MainText")!, range: NSRange(location: 0, length: statementAttributedString.string.utf16.count))
        
        textField.attributedText = statementAttributedString
        
        
        
        UITextViewWrapper.recalculateHeight(view: textField, result: $calculatedHeight)
        return textField
    }
    
    func resetTapped() {
        
    }
    
    func stringFromStatement(_ theStatement: Statement) -> NSMutableAttributedString {
        if let cTheStatement = theStatement as? JunctureStatement {
            let attributedBase = NSMutableAttributedString(string: cTheStatement.leftContent)
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: theStatement.type == .conjunction ? "and" : theStatement.type == .conditional ? "then" : "or")?.withTintColor(UIColor(Color.accentColor))
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
        return Coordinator(deleteWrapper: $deleteWrapper, statement: statement, height: $calculatedHeight, onDone: onDone, isEditing: $isEditing, selectedProposition: $selectedProposition, newJustificationRequest: $newJustificationRequest, selectedJustificationReferences: $selectedJustificationReferences, forceBranching: forceBranching)
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
        var targetingSymbolsCount: Int = 0
        var minusCount = 0
        var justificationEditingMode = false
        var targetingType: TargetingType = .add
        var save: Bool = true
        
        let forceBranching: Bool
        
        var targetedHalf: Int?
        
        let typesForTags = ["and" : StatementType.conjunction, "or" : StatementType.disjunction, "then" : StatementType.conditional, "not" : StatementType.negation]
        let tagsForTypes = [StatementType.conjunction : "and", StatementType.disjunction: "or", StatementType.conditional : "then", StatementType.negation : "not"]
        let imageNames = [StatementType.conjunction : "and", StatementType.disjunction : "or", StatementType.conditional : "then", StatementType.negation : "not"]

        init(deleteWrapper: Binding<Int>, statement: Statement, height: Binding<CGFloat>, onDone: (() -> Void)? = nil, isEditing: Binding<UUID?>, selectedProposition: Binding<Proposition?>, newJustificationRequest: Binding<JustificationType?>, selectedJustificationReferences: Binding<[Int]>, forceBranching: Bool) {
            self.deleteWrapper = deleteWrapper
            self.statement = statement
            self.calculatedHeight = height
            self.onDone = onDone
            self.isEditing = isEditing
            self.selectedProposition = selectedProposition
            self.newJustificationRequest = newJustificationRequest
            self.selectedJustificationReferences = selectedJustificationReferences
            self.liveStatementType = statement.type
            self.forceBranching = forceBranching
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
                    targetingSymbolsCount -= 1
                    statement.targetStatementAtCount(count: targetingSymbolsCount-minusCount <= 0 ? nil : targetingSymbolsCount-minusCount-(self.liveStatementType == .simple ? 1 : 2), type: targetingType, senderID: statement.id)
                    if (self.liveStatementType != .simple) && targetingSymbolsCount == 1 {
                        targetedHalf = highlightSubsentence(textField: textView)
                    } else {
                        clearHighlighting(textField: textView)
                        targetedHalf = nil
                    }
                }
                if potentialTS == "-" {
                    targetingSymbolsCount -= 1
                    minusCount -= 1
                    if minusCount <= 0 {
                        targetingType = .add
                        statement.targetStatementAtCount(count: targetingSymbolsCount-minusCount <= 0 ? nil : targetingSymbolsCount-minusCount-(self.liveStatementType == .simple ? 1 : 2), type: targetingType, senderID: statement.id)
                        if (self.liveStatementType != .simple) && targetingSymbolsCount == 1 {
                            targetedHalf = highlightSubsentence(textField: textView)
                        } else {
                            clearHighlighting(textField: textView)
                            targetedHalf = nil
                        }
                    }
                }
            }
            
            if text == "?" {
                print("content: \(statement.content), formula: \(statement.formula), structure: \(statement.structure), id: \(statement.id)")
            }
            
            if text == ":" || text == "-" {
                let textViewText = textView.text ?? ""
                var currentCharacter = text
                targetingSymbolsCount = 0
                minusCount = 0
                while currentCharacter == ":" || currentCharacter == "-" {
                    targetingSymbolsCount += 1
                    let lowerBound = max(range.location - targetingSymbolsCount, 0)
                    let upperBound = min(lowerBound + 1, textViewText.count)
                    
                    if currentCharacter == "-" {
                        minusCount += 1
                    }
                    
                    currentCharacter = String(textViewText[lowerBound..<upperBound])
                    print(currentCharacter)
                    
                    
                }
                //targetingSymbolsCount -= 1
                if minusCount > 0 {
                    targetingType = .deleteOchange
                }
                
                let targetNumber = targetingSymbolsCount - minusCount - (self.liveStatementType == .simple ? 1 : 2)
                if targetNumber >= (self.liveStatementType == .simple ? 0 : -1) {
                    if let target = statement.target {
                        print("targeting: \(targetNumber)")
                        statement.targetStatementAtCount(count: nil, type: targetingType, senderID: statement.id)
                        statement.targetStatementAtCount(count: targetNumber, type: targetingType, senderID: statement.id)
                        if (self.liveStatementType != .simple) && targetingSymbolsCount == 1 {
                            targetedHalf = highlightSubsentence(textField: textView)
                        } else {
                            clearHighlighting(textField: textView)
                            targetedHalf = nil
                        }
                    }
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
                
                if targetingSymbolsCount > 0 {
                    
                    var noTagsMatched = true
                    
                    for (tag, statementType) in typesForTags {
                        let lowerBound = max(range.location - tag.count - 1, 0)
                        let upperBound = range.location
                        
                        let potentialTag = textViewText[lowerBound..<upperBound]
                        print(potentialTag)
                        
                        if potentialTag == ":"+tag || potentialTag == "-"+tag {
                            //we matched a tag! let's create the image and replace the text
                            noTagsMatched = false
                            
                            if statementType == .conjunction || statementType == .disjunction || statementType == .conditional {
                                //on a conjunction or disjunction, we can keep editing in this configuration
                                textView.attributedText = textViewReplacementStringForSybom(oldString: textView.attributedText, currentLocation: range.location, type: statementType)
                                if liveStatementType != .simple {
                                    secondSymbolType = statementType
                                    shouldStopEditing = false
                                    textView.resignFirstResponder()
                                } else {
                                    liveStatementType = statementType
                                    if targetingSymbolsCount-minusCount-1 > 0 || forceBranching {
                                        shouldStopEditing = false
                                        textView.resignFirstResponder()
                                    } else {
                                        targetingSymbolsCount = 0
                                        minusCount = 0
                                        targetingType = .add
                                        statement.targetStatementAtCount(count: nil, type: targetingType, senderID: statement.id)
                                        clearHighlighting(textField: textView)
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
                    
                    if noTagsMatched {
//                        let lowerBound = max(range.location - targetingSymbolsCount, 0)
//                        let upperBound = range.location
//
//                        let potentialTag = textViewText[lowerBound..<upperBound]
//                        print(potentialTag)
//
//
                        
                        if minusCount > 0 {
                            shouldStopEditing = false
                            save = false
                            let continueID = Statement()
                            print("IS EDITING CHANGED from: \(isEditing.wrappedValue), to: \(continueID.id), editedStatementID: \(statement.id)")
                            isEditing.wrappedValue = continueID.id
                            statement.addAtTargeted(connectionType: .simple, connectTo: continueID)
                        }
                        
                        let newString = NSMutableAttributedString(attributedString: textView.attributedText)
                        let tagLength = targetingSymbolsCount
                        newString.replaceCharacters(in: NSRange(location: range.location-tagLength, length: tagLength), with: "")
                        newString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AvenirNext-Medium", size: 17) ?? .boldSystemFont(ofSize: 10), range: NSRange(location: 0, length: newString.string.utf16.count))
                        textView.attributedText = newString
                        
                        statement.targetStatementAtCount(count: nil, type: .add, senderID: statement.id)
                        clearHighlighting(textField: textView)
                        targetingSymbolsCount = 0
                        minusCount = 0
                        
                        //isEditing.wrappedValue = statement.id
                        
                    }
                    
                }
            }
            
            //attempting to delete wrapper:
            if range.location == 0 && text == "" {
                deleteWrapper.wrappedValue += 1
                if deleteWrapper.wrappedValue == 2 {
                    statement.targetStatementAtCount(count: 1, type: .deleteOchange, senderID: statement.id)
                } else if deleteWrapper.wrappedValue == 3 {
                    shouldStopEditing = false
                    let continueID = Statement()
                    print("IS EDITING CHANGED from: \(isEditing.wrappedValue), to: \(continueID.id), editedStatementID: \(statement.id)")
                    isEditing.wrappedValue = continueID.id
                    statement.addAtTargeted(connectionType: .simple, connectTo: Statement())
                }
            } else if deleteWrapper.wrappedValue > 0 {
                deleteWrapper.wrappedValue = 0
                statement.targetStatementAtCount(count: nil, type: .add, senderID: statement.id)
                clearHighlighting(textField: textView)
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
            if self.save {
                save(forText: textView.attributedText)
                print("SAVE COMPLETE!!")
            }
            
            print("Back in did end editing! shouldStopEditing is: \(shouldStopEditing)")
            if shouldStopEditing {
                print("Setting isEditing to nil.")
                print("IS EDITING CHANGED from: \(isEditing.wrappedValue), to: nil, editedStatementID: \(statement.id)")
                isEditing.wrappedValue = nil
            }
            print("shouldStopEditing is now true again!")
            //textView.text = "FUCK!"
            print("\(statement.id) is my statement")
            shouldStopEditing = true
            save = true
            statement.targetStatementAtCount(count: nil, type: targetingType, senderID: statement.id)
            clearHighlighting(textField: textView)
            targetingSymbolsCount = 0
        }
        
        func save(forText endText: NSAttributedString) {
            if statement.type == liveStatementType && secondSymbolType == nil {
                if statement.type == .disjunction || statement.type == .conjunction || statement.type == .conditional {
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
                        if let targetedPart = targetedHalf {
                            switch secondSymbolType {
                            case .conditional:
                                if targetedPart == 1 {
                                    currentStatementTransform = Conditional(currentStatementTransform, Statement())
                                } else {
                                    splitPieceStatement = Conditional(splitPieceStatement, Statement())
                                }
                                
                            case .conjunction:
                                if targetedPart == 1 {
                                    currentStatementTransform = Conjunction(currentStatementTransform, Statement())
                                } else {
                                    splitPieceStatement = Conjunction(splitPieceStatement, Statement())
                                }
                                
                            case .disjunction:
                                if targetedPart == 1 {
                                    currentStatementTransform = Disjunction(currentStatementTransform, Statement())
                                } else {
                                    splitPieceStatement = Disjunction(splitPieceStatement, Statement())
                                }
                                
                            case .negation:
                                if targetedPart == 1 {
                                    currentStatementTransform = Negation(currentStatementTransform)
                                } else {
                                    splitPieceStatement = Negation(currentStatementTransform)
                                }
                                
                            default:
                                print("Error. No simbol for simple statements wtf")
                            }
                        } else {
                            switch liveStatementType {
                            case .conjunction:
                                currentStatementTransform = Conjunction(currentStatementTransform, splitPieceStatement)
                                splitPieceStatement = Statement()
                                
                            case .disjunction:
                                currentStatementTransform = Disjunction(currentStatementTransform, splitPieceStatement)
                                splitPieceStatement = Statement()
                                
                            case .conditional:
                                currentStatementTransform = Conditional(currentStatementTransform, splitPieceStatement)
                                splitPieceStatement = Statement()

                            default:
                                print("Some kind of error")
                            }
                            
                        }
                        
                        
                    }
                    
                    print("IS EDITING CHANGED from: \(isEditing.wrappedValue), to: \(currentStatementTransform.id), editedStatementID: \(statement.id)")
                    self.isEditing.wrappedValue = currentStatementTransform.id
                    if let uChange = statement.change {
                        uChange(statement.id, currentStatementTransform)
                    }
                    currentStatementTransform.id = statement.id
                    currentStatementTransform.delete = statement.delete
                    currentStatementTransform.change = statement.change
                    currentStatementTransform.target = statement.target
                    currentStatementTransform.changeTarget = statement.changeTarget
                    currentStatementTransform.targeted = statement.targeted
                    currentStatementTransform.targetingIntent = statement.targetingIntent
                    
                    var type: StatementType = .conjunction
                    if let secondS = secondSymbolType {
                        if targetedHalf != nil {
                            type = liveStatementType
                        } else {
                            type = secondS
                        }
                    } else {
                        type = liveStatementType
                    }
                    //self.isEditing.wrappedValue = splitPieceStatement.id
                    
//                    if let uChangeTarget = currentStatementTransform.changeTarget {
//                        uChangeTarget(type, splitPieceStatement)
//                    }
                    print("IS EDITING CHANGED from: \(isEditing.wrappedValue), to: nil, editedStatementID: \(statement.id)")
                    self.isEditing.wrappedValue = nil
                    
                    if targetingSymbolsCount == 0 && secondSymbolType == nil {
                        currentStatementTransform.targetStatementAtCount(count: 0, type: .add, senderID: currentStatementTransform.id)
                    } else if targetingSymbolsCount == 1 && targetedHalf != nil {
                        currentStatementTransform.targetStatementAtCount(count: 0, type: .add, senderID: currentStatementTransform.id)
                    }
                    currentStatementTransform.addAtTargeted(connectionType: type, connectTo: splitPieceStatement)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0051) {
                        if self.targetedHalf == 1 {
                            print("IS EDITING CHANGED from: \(self.isEditing.wrappedValue), to: \(currentStatementTransform.id), editedStatementID: \(self.statement.id)")
                            self.isEditing.wrappedValue = currentStatementTransform.id
                        } else {
                            print("IS EDITING CHANGED from: \(self.isEditing.wrappedValue), to: \(splitPieceStatement.id), editedStatementID: \(self.statement.id)")
                            self.isEditing.wrappedValue = splitPieceStatement.id
                        }
    
                    }
                    //print("SPLIT PIECE STATEMENT CONTENT: \(splitPieceStatement)")
                    //currentStatementTransform.target(nil)
                }
            }
        }
        
        func highlightSubsentence(textField: UITextView) -> Int? {
            let selected = textField.selectedRange
            if let selectedRange = textField.selectedTextRange {
                let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
                print("\(cursorPosition)")
                if let logicSymbolRange = self.rangeForLogicSymbol(attributedText: textField.attributedText) {
                    let firstHalfRange = NSRange(location: 0, length: logicSymbolRange.location)
                    let secondHalfRange = NSRange(location: logicSymbolRange.location, length: textField.attributedText.length - logicSymbolRange.location)
                    
                    if firstHalfRange.contains(cursorPosition) {
                        let highlightedPart = textField.attributedText.attributedSubstring(from: firstHalfRange)
                        let dimmedPart: NSMutableAttributedString = NSMutableAttributedString(attributedString: textField.attributedText.attributedSubstring(from: secondHalfRange))
                        
                        dimmedPart.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "MainText")?.withAlphaComponent(0.1) ?? .red, range: NSRange(location: 0, length: dimmedPart.string.utf16.count))
                        
                        let fullAssemble = NSMutableAttributedString(attributedString: highlightedPart)
                        fullAssemble.append(dimmedPart)
                        
                        textField.attributedText = fullAssemble
                        textField.selectedRange = selected
                        
                        return 1
                        
                    } else {
                        let highlightedPart = textField.attributedText.attributedSubstring(from: secondHalfRange)
                        let dimmedPart: NSMutableAttributedString = NSMutableAttributedString(attributedString: textField.attributedText.attributedSubstring(from: firstHalfRange))
                        
                        dimmedPart.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "MainText")?.withAlphaComponent(0.1) ?? .red, range: NSRange(location: 0, length: dimmedPart.string.utf16.count))
                        
                        let fullAssemble = NSMutableAttributedString(attributedString: dimmedPart)
                        fullAssemble.append(highlightedPart)
                        
                        textField.attributedText = fullAssemble
                        textField.selectedRange = selected
                        
                        return 2
                    }
                }
            }
            
            return nil
        }
        
        func clearHighlighting(textField: UITextView) {
            let selected = textField.selectedRange
            
            let proxyAttributed:NSMutableAttributedString = NSMutableAttributedString(attributedString: textField.attributedText)
            proxyAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "MainText") ?? .red, range: NSRange(location: 0, length: proxyAttributed.string.utf16.count))
            
            textField.attributedText = proxyAttributed
            textField.selectedRange = selected
        }
        
        func updateTarget(moveHere: Statement) {
            let type = secondSymbolType != nil ? secondSymbolType! : liveStatementType
            print("IS EDITING CHANGED from: \(self.isEditing.wrappedValue), to: \(moveHere.id), editedStatementID: \(self.statement.id)")
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
            return (type == .negation || liveStatementType != .simple) ? NSAttributedString(string: "") : NSAttributedString(attachment: attachment)
        }
        
        func textViewReplacementStringForSybom(oldString: NSAttributedString, currentLocation: Int, type: StatementType) -> NSAttributedString {
            let newString = NSMutableAttributedString(attributedString: oldString)
            let tagLength = tagsForTypes[type]!.count + targetingSymbolsCount
            newString.replaceCharacters(in: NSRange(location: currentLocation-tagLength, length: tagLength), with: attributedStringForSymbol(type: type))
            newString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AvenirNext-Medium", size: 17) ?? .boldSystemFont(ofSize: 10), range: NSRange(location: 0, length: newString.string.utf16.count))
            
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
