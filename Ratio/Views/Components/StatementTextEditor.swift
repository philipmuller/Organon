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
    @Binding var statement: Statement
    @Binding var deleteWrapper: Int
    @Binding var isEditing: UUID?
    
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.shouldShowPlaceholder = $0.isEmpty
        }
    }
    
    private var internalStatement: Binding<Statement> {
        Binding<Statement>(get: { self.statement } ) {
            self.statement = $0
        }
    }
    
    private var internalDeleteCount: Binding<Int> {
        Binding<Int>(get: { self.deleteWrapper } ) {
            self.deleteWrapper = $0
        }
    }

    var body: some View {
        UITextViewWrapper(deleteWrapper: internalDeleteCount, statement: internalStatement, text: internalText, calculatedHeight: $viewHeight, isEditing: $isEditing, onDone: onCommit)
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
    
    init (bindedStatement: Binding<Statement>, deleteTracker: Binding<Int>, placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil, isEditing: Binding<UUID?>) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._statement = bindedStatement
        self._deleteWrapper = deleteTracker
        self._isEditing = isEditing
        self._shouldShowPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

}


private struct UITextViewWrapper: UIViewRepresentable {
    //typealias UIViewType = UITextView

    @Binding var deleteWrapper: Int
    @Binding var statement: Statement
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    @Binding var isEditing: UUID?
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

    private static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // call in next render cycle.
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(deleteWrapper: $deleteWrapper, statement: $statement, text: $text, height: $calculatedHeight, onDone: onDone, isEditing: $isEditing)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var deleteWrapper: Binding<Int>
        var statement: Binding<Statement>
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        var editedStatementType: StatementType
        var isEditing: Binding<UUID?>
        
        let typesForTags = [":and:" : StatementType.conjunction, ":or:" : StatementType.disjunction, ":then:" : StatementType.conditional, ":not:" : StatementType.negation]
        let tagsForTypes = [StatementType.conjunction : ":and:", StatementType.disjunction: ":or:", StatementType.conditional : ":then:", StatementType.negation : ":not:"]
        let imageNames = [StatementType.conjunction : "and", StatementType.disjunction : "or", StatementType.conditional : "then", StatementType.negation : "not"]

        init(deleteWrapper: Binding<Int>, statement: Binding<Statement>, text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil, isEditing: Binding<UUID?>) {
            self.deleteWrapper = deleteWrapper
            self.statement = statement
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
            self.isEditing = isEditing
            self.editedStatementType = statement.wrappedValue.type
        }

        func textViewDidChange(_ uiView: UITextView) {
            //text.wrappedValue = uiView.text
            if isEditing.wrappedValue == statement.id.wrappedValue {
                uiView.becomeFirstResponder()
            }
            
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            print("range: \(range), replacementText: \(text)")
            
            //Check if logical operator symbol is about to be deleted
            if let symbolRange = rangeForLogicSymbol(attributedText: textView.attributedText) {
                if range.contains(symbolRange.location) {
                    //this assumes that only 1 symbol can be present at any given point
                    //the symbol is deleted, so we change the statement type to simple
                    editedStatementType = .simple
                }
            }
            
            //Check if written text is an logical operator tag
            
            if text == " " { //if the new text that wants to be inserted is a space
                //check if the previous characters are a match to the tag:
                let textViewText = textView.text ?? ""
                for (tag, statementType) in typesForTags {
                    let lowerBound = range.location - tag.count
                    let upperBound = range.location
                    
                    let potentialTag = textViewText[lowerBound..<upperBound]
                    print(potentialTag)
                    
                    if potentialTag == tag {
                        //we matched a tag! let's create the image and replace the text
                        if statementType == .conjunction || statementType == .disjunction {
                            //on a conjunction or disjunction, we can keep editing in this configuration
                            //TODO: WHAT HAPPENS IF THERE IS A SECOND CONJUNCTION OR DISJUNCTION TAG?!
                            textView.attributedText = textViewReplacementStringForSybom(oldString: textView.attributedText, currentLocation: range.location, type: statementType)
                            editedStatementType = statementType
                        } else {
                            //on anything else, we have to update the entire ui first, to match the writing
                            editedStatementType = statementType
                            //textView.resignFirstResponder()
                            //isEditing.wrappedValue = nil
                            updateStatement(statement, forText: textView.attributedText, editedType: statementType)
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
                updateStatement(statement, forText: textView.attributedText, editedType: editedStatementType)
                isEditing.wrappedValue = nil
                return false
            }
            
            
            return true
        }
        
        func updateStatement(_ ogStatement: Binding<Statement>, forText finishedText: NSAttributedString, editedType: StatementType) {
            
            if let uChange = ogStatement.wrappedValue.change {
                if let uDelete = ogStatement.wrappedValue.delete {
                    // if we have acces to delete and change closures that we can call
                    
                    if finishedText.string != "" || finishedText.string != " " || finishedText.string != "  " {
                        //if the text field is not empty (we don't want to delete but change)
                        
                        var changeToStatement = Statement()
                        var nextResponderID = changeToStatement.id
                        
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
                        }
                        
                        //check if the new statement is structurally different to the old statement
                        if ogStatement.wrappedValue.type == editedType {
                            //the statement has the same type, just update the text
                            ogStatement.wrappedValue.content = finishedText.string
                        } else {
                            //change the structure, call the closure
                            //isEditing.wrappedValue = changeToStatement.id
                            isEditing.wrappedValue = nextResponderID
                            uChange(ogStatement.wrappedValue.id, changeToStatement)
                        }
                        
                    } else {
                        //the text field is empty, delete this statement
                        uDelete(ogStatement.wrappedValue.id)
                    }
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
            return NSAttributedString(attachment: attachment)
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
