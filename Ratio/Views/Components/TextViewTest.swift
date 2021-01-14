//
//  TextViewTest.swift
//  Ratio
//
//  Created by Philip Müller on 20/12/20.
//

import SwiftUI

struct AttributedTextFromFileView: UIViewRepresentable {
    
    let statement: String
    
    func makeUIView(context: Context) -> UITextView {
      let uiTextView = UITextView()
      uiTextView.delegate = context.coordinator
      uiTextView.isEditable = true
      uiTextView.isScrollEnabled = false
        uiTextView.font = UIFont(name: "AvenirNext-Medium", size: 16)
        uiTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        uiTextView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        uiTextView.adjustsFontForContentSizeCategory = false
      UITextView.appearance().backgroundColor = .red
      
      let emojiDict: [String: String] = [" and ": "and", " or ": "or", " not ": "not"]

      let attributedString = NSMutableAttributedString(string: statement)

      for (anEmojiTag, anEmojiImageName) in emojiDict {
          let pattern = NSRegularExpression.escapedPattern(for: anEmojiTag)
          let regex = try? NSRegularExpression(pattern: pattern,
                                               options: [])
          if let matches = regex?.matches(in: attributedString.string,
                                          options: [],
                                          range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
              for aMatch in matches.reversed() {
                  let attachment = NSTextAttachment()
                  attachment.image = UIImage(named: anEmojiImageName)
                  //attachment.bounds = something //if you need to resize your images
                  let replacement = NSAttributedString(attachment: attachment)
                  attributedString.replaceCharacters(in: aMatch.range, with: replacement)
              }
          }
      }
      
      //uiTextView.attributedText = attributedString
        uiTextView.text = statement
      return uiTextView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
      print("i ran")
    }
    
    class Coordinator : NSObject, UITextViewDelegate {

            var parent: AttributedTextFromFileView

            init(_ uiTextView: AttributedTextFromFileView) {
                self.parent = uiTextView
            }

            func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                print("Not working")
                return true
            }

            func textViewDidChange(_ textView: UITextView) {
                let attributedString = NSMutableAttributedString(attributedString: textView.attributedText!)
                    
                let emojiDict: [String: String] = [" and ": "and", " or ": "or", " not ": "not"]

                for (anEmojiTag, anEmojiImageName) in emojiDict {
                    let pattern = NSRegularExpression.escapedPattern(for: anEmojiTag)
                    let regex = try? NSRegularExpression(pattern: pattern,
                                                         options: [])
                    if let matches = regex?.matches(in: attributedString.string,
                                                    options: [],
                                                    range: NSRange(location: 0, length: attributedString.string.utf16.count)) {
                        for aMatch in matches.reversed() {
                            let attachment = NSTextAttachment()
                            attachment.image = UIImage(named: anEmojiImageName)
                            //attachment.bounds = something //if you need to resize your images
                            let replacement = NSAttributedString(attachment: attachment)
                            attributedString.replaceCharacters(in: aMatch.range, with: replacement)
                        }
                    }
                }
                
                textView.attributedText = attributedString
            }


        }
  
}

struct AttributedTextFromFileView_Previews: PreviewProvider {
  static let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed imperdiet condimentum facilisis. Morbi gravida, massa et malesuada venenatis, elit nisl aliquam nisi, sed fermentum massa libero id leo. Integer pellentesque nunc sit amet sem suscipit, sit amet imperdiet nibh facilisis. Nunc quis leo vitae ipsum tempor condimentum eget in massa. Nam ut ultrices neque, iaculis sodales urna. Nulla facilisi. Vivamus dictum mauris sed pretium tempor. Phasellus maximus semper mauris in porttitor. Sed a turpis risus."
    
  static var previews: some View {
    AttributedTextFromFileView(statement: "This is cool and this is even cooler")
      .padding(.horizontal, 40)
  }
}
