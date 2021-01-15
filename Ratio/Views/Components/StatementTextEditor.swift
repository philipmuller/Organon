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
        UITextViewWrapper(deleteWrapper: internalDeleteCount, statement: internalStatement, text: internalText, calculatedHeight: $viewHeight, onDone: onCommit)
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
    
    init (bindedStatement: Binding<Statement>, deleteTracker: Binding<Int>, placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._statement = bindedStatement
        self._deleteWrapper = deleteTracker
        self._shouldShowPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

}


private struct UITextViewWrapper: UIViewRepresentable {
    //typealias UIViewType = UITextView

    @Binding var deleteWrapper: Int
    @Binding var statement: Statement
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var becomeResponder: Bool = true
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont(name: "AvenirNext-Medium", size: 16)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        if onDone != nil {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        //if textField.window != nil, !textField.isFirstResponder {
            textField.becomeFirstResponder()
        //}
        
        textField.attributedText = stringFromStatement(statement)
        
        
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
            attributedBase.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AvenirNext-Medium", size: 16), range: NSRange(location: 0, length: attributedBase.string.utf16.count))
            attributedBase.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "MainText"), range: NSRange(location: 0, length: attributedBase.string.utf16.count))
            return attributedBase
        } else {
            return NSMutableAttributedString(string: theStatement.content ?? "error")
        }
    }
    
    //func view

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
//        if uiView.text != self.text {
//            uiView.text = self.text
//        }
        print("UPDATE VIEW GOT CALLED")
        
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
        
//        let connectiveDictionary: [String: String] = [" and ": "and", " or ": "or", " not ": "not"]
//
//        let attributedString = NSMutableAttributedString(string: self.text)
//
//        for (connectiveTrigger, triggerImageName) in connectiveDictionary {
//            let pattern = NSRegularExpression.escapedPattern(for: connectiveTrigger)
//            let regex = try? NSRegularExpression(pattern: pattern, options: [])
//
//            if let matches = regex?.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
//
//                for aMatch in matches.reversed() {
//                    let attachment = NSTextAttachment()
//                    attachment.image = UIImage(named: triggerImageName)
//                    let replacement = NSAttributedString(attachment: attachment)
//                    attributedString.replaceCharacters(in: aMatch.range, with: replacement)
//                }
//            }
//        }
        
//        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AvenirNext-Medium", size: 16), range: NSRange(location: 0, length: attributedString.string.utf16.count))
        
        //let selectedRange: NSRange = uiView.selectedRange;
        //uiView.attributedText = NSAttributedString(string: text)
        //uiView.selectedRange = selectedRange;
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
        return Coordinator(deleteWrapper: $deleteWrapper, statement: $statement, text: $text, height: $calculatedHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var deleteWrapper: Binding<Int>
        var statement: Binding<Statement>
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?

        init(deleteWrapper: Binding<Int>, statement: Binding<Statement>, text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.deleteWrapper = deleteWrapper
            self.statement = statement
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            //text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            print("range: \(range), replacementText: \(text)")
            
            if range.location == 0 && text == "" {
                deleteWrapper.wrappedValue += 1
            }
            
            if text == " " {
                let gText = textView.text ?? ""
                let startIndex = gText.index(gText.endIndex, offsetBy: -4)
                print(gText[startIndex...])
                if gText[startIndex...] == " and" {
                    print("IT'S A MATCH")
                    
                    let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: "and")?.withTintColor(UIColor(Color.accentColor))
                    let replacement = NSAttributedString(attachment: attachment)
                    attributedString.replaceCharacters(in: NSRange(location: range.location-3, length: 3), with: replacement)
                    attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AvenirNext-Medium", size: 16), range: NSRange(location: 0, length: attributedString.string.utf16.count))
                    
                    textView.attributedText = attributedString
                }
            }
            
            if text == "\n" {
                textView.resignFirstResponder()
                self.statement.wrappedValue = updateStatement(self.statement.wrappedValue, forText: textView.attributedText)
                return false
            }
            
            
            return true
        }
        
        func updateStatement(_ ogStatement: Statement, forText finishedText: NSAttributedString) -> Statement {
            
            var cStatement = Conjunction(Statement(content: "work in progress", formula: "W"), Statement(content: "junction not supported", formula: "N"))
            
            if finishedText.string != "" || finishedText.string != " " || finishedText.string != "  " {
                //the text contains something
                if finishedText.containsAttachments(in: NSRange(location: 0, length: finishedText.string.utf16.count)) {
                    //it is a complex statement. We'll assume that it only has 2 components for now
                    //we have to detect what the attachment is
                    finishedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: finishedText.string.utf16.count), options: .longestEffectiveRangeNotRequired) { value, range, bool in
                        if value != nil {
                            print(value.debugDescription)
                            print(range.debugDescription)
                            //the code that follows is extremely unsafe. It rests on the assumption that all written text contains only 2 simple statements and that the junction type is always "and"
                            let middleBound = finishedText.string.index(finishedText.string.startIndex, offsetBy: range.location)
                            let firstStatement = Statement(content: String(finishedText.string[..<middleBound]), formula: "A")
                            let secondStatement = Statement(content: String(finishedText.string[middleBound..<finishedText.string.endIndex]), formula: "B")
                            
                            cStatement = Conjunction(firstStatement, secondStatement)
                        }
                    }

                } else {
                    //not a complex statement
                }
            } else {
                //the text is empty or meaningless
                return Statement(content: "this should be deleted somehow", formula: "A")
            }
            
            
            return cStatement
            
        }
        
        
        
        //func statementFrom(_ attributedString)
    }

}
