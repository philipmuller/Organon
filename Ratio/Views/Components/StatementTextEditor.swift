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
    @Binding private var text: String
    @ObservedObject var statement: Statement
    @Binding var deleteWrapper: Int
    @Binding var isEditing: UUID?
    @Binding var selectedProposition: Proposition?
    
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.shouldShowPlaceholder = $0.isEmpty
        }
    }
    
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
        UITextViewWrapper(deleteWrapper: internalDeleteCount, statement: statement, text: internalText, calculatedHeight: $viewHeight, isEditing: $isEditing, selectedProposition: $selectedProposition, onDone: onCommit)
            .frame(minHeight: viewHeight, maxHeight: viewHeight)
            .offset(x: -5, y: -8)
            .background(placeholderView, alignment: .topLeading)
            .padding(0)
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
    
    init (bindedStatement: Statement, deleteTracker: Binding<Int>, placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil, isEditing: Binding<UUID?>, selectedProposition: Binding<Proposition?>) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self.statement = bindedStatement
        self._deleteWrapper = deleteTracker
        self._isEditing = isEditing
        self._selectedProposition = selectedProposition
        self._shouldShowPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

}


private struct UITextViewWrapper: UIViewRepresentable {
    //typealias UIViewType = UITextView

    @Binding var deleteWrapper: Int
    @ObservedObject var statement: Statement
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    @Binding var isEditing: UUID?
    @Binding var selectedProposition: Proposition?
    var becomeResponder: Bool = true
    var onDone: (() -> Void)?

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
            attachment.image = UIImage(named: "and")?.withTintColor(UIColor(Color.accentColor))
            let attachmentS = NSAttributedString(attachment: attachment)
            attributedBase.append(attachmentS)
            attributedBase.append(NSAttributedString(string: cTheStatement.rightContent))
            return attributedBase
        } else {
            return NSMutableAttributedString(string: theStatement.content)
        }
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {

        print("UPDATE VIEW GOT CALLED")
        if isEditing == statement.id {
            uiView.becomeFirstResponder()
        }
        
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
        
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
        return Coordinator(deleteWrapper: $deleteWrapper, statement: statement, text: $text, height: $calculatedHeight, onDone: onDone, isEditing: $isEditing, selectedProposition: $selectedProposition)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var deleteWrapper: Binding<Int>
        @ObservedObject var statement: Statement
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        var liveStatementType: StatementType
        var secondSymbolType: StatementType?
        var isEditing: Binding<UUID?>
        var selectedProposition: Binding<Proposition?>
        var shouldStopEditing = true
        
        let typesForTags = [":and" : StatementType.conjunction, ":or" : StatementType.disjunction, ":then" : StatementType.conditional, ":not" : StatementType.negation]
        let tagsForTypes = [StatementType.conjunction : ":and", StatementType.disjunction: ":or", StatementType.conditional : ":then", StatementType.negation : ":not"]
        let imageNames = [StatementType.conjunction : "and", StatementType.disjunction : "or", StatementType.conditional : "then", StatementType.negation : "not"]

        init(deleteWrapper: Binding<Int>, statement: Statement, text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil, isEditing: Binding<UUID?>, selectedProposition: Binding<Proposition?>) {
            self.deleteWrapper = deleteWrapper
            self.statement = statement
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
            self.isEditing = isEditing
            self.selectedProposition = selectedProposition
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
            
            if text == ":" {
                let textViewText = textView.text ?? ""
                var currentCharacter = text
                var count = 1
                while currentCharacter == ":" {
                    let lowerBound = max(range.location - count, 0)
                    let upperBound = min(lowerBound + 1, textViewText.count)
                    currentCharacter = String(textViewText[lowerBound..<upperBound])
                    print(currentCharacter)
                    count += 1
                }
                count -= 2
                if let target = statement.target {
                    print("targeting: \(count)")
                    statement.targetStatementAtCount(count: nil)
                    statement.targetStatementAtCount(count: count)
                }
            }
            
            //Check if written text is an logical operator tag
            
            if text == " " { //if the new text that wants to be inserted is a space
                //check if the previous characters are a match to the tag:
                let textViewText = textView.text ?? ""
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
                                print("Found then tag, shouldstopediting = false and we resign responder")
                                secondSymbolType = statementType
                                shouldStopEditing = false
                                textView.resignFirstResponder()
                            } else {
                                liveStatementType = statementType
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
            shouldStopEditing = true
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
                    let leftStatement = Statement(content: simpleTextLeft, formula: "A")
                    let rightStatement = Statement(content: simpleTextRight, formula: "B")
                    
                    junctionWrapper.firstChild = leftStatement
                    junctionWrapper.secondChild = rightStatement
                    
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
                    var splitPieceStatement = Statement()
                    
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
                    
                    if let uChange = statement.change {
                        uChange(statement.id, currentStatementTransform)
                    }
                    currentStatementTransform.delete = statement.delete
                    currentStatementTransform.change = statement.change
                    currentStatementTransform.target = statement.target
                    currentStatementTransform.changeTarget = statement.changeTarget
                    currentStatementTransform.targeted = statement.targeted
                    
                    let type = secondSymbolType != nil ? secondSymbolType! : liveStatementType
                    self.isEditing.wrappedValue = splitPieceStatement.id
                    
                    currentStatementTransform.addAtTargeted(connectionType: type, connectTo: splitPieceStatement)
                    print("SPLIT PIECE STATEMENT CONTENT: \(splitPieceStatement.content)")
                }
            }
        }
        
        func updateTarget(moveHere: Statement) {
            let type = secondSymbolType != nil ? secondSymbolType! : liveStatementType
            self.isEditing.wrappedValue = moveHere.id
            statement.addAtTargeted(connectionType: type, connectTo: moveHere)
        }
        
        func updateStatement(forText finishedText: NSAttributedString, editedType: StatementType, secondSymbolType: StatementType?) {
            print("Update statement called. ogstatement type: \(statement.type), finished text: \(finishedText.string) editedType: \(editedType) second symbol type: \(secondSymbolType)")
            
            if statement.type == editedType && secondSymbolType == nil {
                //no structural changes required. Update og statement directly
                if statement.type == .disjunction || statement.type == .conjunction {
                    var junctionBinding: JunctureStatement {
                        get {
                            self.statement as! JunctureStatement
                        }
                        set {
                            self.statement = newValue
                        }
                    }
//                    var junctionBinding: JunctureStatement {
//                        get: {self.statement as! JunctureStatement}, set: {self.statement = $0}}
                    
                    var cuttingPoint = finishedText.string.count
                    if let symbolPosition = rangeForLogicSymbol(attributedText: finishedText)?.location {
                        cuttingPoint = symbolPosition
                    }
                    let lowerBound = 0
                    let upperBound = finishedText.string.count
                    let simpleTextLeft = String(finishedText.string[lowerBound..<cuttingPoint])
                    let simpleTextRight = String(finishedText.string[cuttingPoint..<upperBound])
                    let leftStatement = Statement(content: simpleTextLeft, formula: "A")
                    let rightStatement = Statement(content: simpleTextRight, formula: "B")
                    
                    junctionBinding.firstChild = leftStatement
                    junctionBinding.secondChild = rightStatement
                    
                } else {
                    statement.content = finishedText.string
                }
            } else {
                if let uChange = statement.change {
                    var changeToStatement = Statement()
                    var nextResponderID = changeToStatement.id
                    print("Initial values. ChangeToStatement = \(changeToStatement), nextResponderID = \(nextResponderID)")
                    
                    if editedType == .simple || editedType == .negation {
                        //these types have just one term
                        let simple = Statement(content: finishedText.string, formula: "A")
                        changeToStatement = editedType == .simple ? simple : Negation(simple)
                        nextResponderID = simple.id
                        
                    } else {
                        //these have two terms, we have to figure out where the logic symbol is (the divider)
                        var cuttingPoint = finishedText.string.count
                        if let symbolPosition = rangeForLogicSymbol(attributedText: finishedText)?.location {
                            cuttingPoint = symbolPosition
                        }
                        let lowerBound = 0
                        let upperBound = finishedText.string.count
                        let simpleTextLeft = String(finishedText.string[lowerBound..<cuttingPoint])
                        let simpleTextRight = String(finishedText.string[cuttingPoint..<upperBound])
                        let leftStatement = Statement(content: simpleTextLeft, formula: "A")
                        let rightStatement = Statement(content: simpleTextRight, formula: "B")
                        
                        
                        switch editedType {
                        case .conditional:
                            changeToStatement = Conditional(leftStatement, rightStatement)
                        case .conjunction:
                            changeToStatement = Conjunction(leftStatement, rightStatement)
                        case .disjunction:
                            changeToStatement = Disjunction(leftStatement, rightStatement)
                        default:
                            changeToStatement = Statement()
                        }
                        nextResponderID = rightStatement.id
                        print("mid values. ChangeToStatement = \(changeToStatement), nextResponderID = \(nextResponderID)")
                    }
                    
                    if secondSymbolType != nil {
                        let freshNewStatement = Statement(content: "", formula: "A")
                        nextResponderID = freshNewStatement.id
                        
                        switch secondSymbolType {
                        case .conjunction:
                            changeToStatement = Conjunction(changeToStatement, freshNewStatement)
                        case .disjunction:
                            changeToStatement = Disjunction(changeToStatement, freshNewStatement)
                        case .conditional:
                            changeToStatement = Conditional(changeToStatement, freshNewStatement)
                        case .negation:
                            nextResponderID = changeToStatement.id
                            changeToStatement = Negation(changeToStatement)
                        default:
                            print("Yeah you fucked up something. Good luck.")
                        }
                    }
                    
                    print("end values. ChangeToStatement = \(changeToStatement), nextResponderID = \(nextResponderID)")
                    print("About to change isEditing ID")
                    isEditing.wrappedValue = nextResponderID
                    print("Changed isEditing ID to: \(isEditing.wrappedValue)")
                    //changeToStatement.id = ogStatement.wrappedValue.id
                    print("About to trigger uChange. Statement to change ID = \(statement.id), change to statemet \(changeToStatement)")
                    uChange(statement.id, changeToStatement)
                    print("Done changing, exiting update function...")
                }
            }
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
            let tagLength = tagsForTypes[type]!.count
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
