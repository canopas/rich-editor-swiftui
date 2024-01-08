//
//  TextViewWrapper.swift
//  
//
//  Created by Divyesh Vekariya on 12/10/23.
//

import SwiftUI

internal struct TextViewWrapper: UIViewRepresentable {
    @ObservedObject var state: RichEditorState
    
    private let isEditable: Bool
    private let isUserInteractionEnabled: Bool
    private let isScrollEnabled: Bool
    private let linelimit: Int?
    private let fontStyle: UIFont?
    private let fontColor: Color
    private let backGroundColor: UIColor
    private let tag: Int?
    
    public init(state: ObservedObject<RichEditorState>,
                isEditable: Bool = true,
                isUserInteractionEnabled: Bool = true,
                isScrollEnabled: Bool = false,
                linelimit: Int? = nil,
                fontStyle: UIFont? = nil,
                fontColor: Color = .black,
                backGroundColor: UIColor = .clear,
                tag: Int? = nil) {
        self._state = state
        
        self.isEditable = isEditable
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.isScrollEnabled = isScrollEnabled
        self.linelimit = linelimit
        self.fontStyle = fontStyle
        self.fontColor = fontColor
        self.backGroundColor = backGroundColor
        self.tag = tag
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> TextViewOverRidden {
        let textView = TextViewOverRidden()
        textView.delegate = context.coordinator
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.isScrollEnabled = isScrollEnabled
        textView.isEditable = isEditable
        textView.isUserInteractionEnabled = isUserInteractionEnabled
        textView.backgroundColor = UIColor.clear
        if let fontStyle {
            textView.typingAttributes = [.font: fontStyle]
        }
        if let fontStyle {
            var fontAttr = AttributeContainer()
            fontAttr.font = fontStyle
            let string = NSMutableAttributedString(string: state.editableText.string, attributes: [.font: fontStyle])
            textView.attributedText = string
        } else {
            textView.attributedText = state.editableText
        }
        
        textView.textColor = UIColor(fontColor)
        textView.textContainer.lineFragmentPadding = 0
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = true
        
        if let attributes = state.activeAttributes {
            textView.typingAttributes = attributes
        }
        
        if let tag = tag {
            textView.tag = tag
        }
        
        if let linelimit = linelimit {
            textView.textContainer.maximumNumberOfLines = linelimit
        }
        
        if let fontStyle = fontStyle {
            let scaledFontSize = UIFontMetrics.default.scaledValue(for: fontStyle.pointSize)
            let scaledFont = fontStyle.withSize(scaledFontSize)
            textView.font = scaledFont
        }
        
        return textView
    }
    
    public func updateUIView(_ textView: TextViewOverRidden, context: Context) {
        textView.textColor = UIColor(fontColor)
        let fullRange = NSRange(location: 0, length: (textView.textStorage.length - 1))
        ///Set typing attributes
        var attributes = getTypingAttributesForStyles(state.activeStyles)
        if !attributes.contains(where: { $0.key == .font }) {
            attributes[.font] = fontStyle
        }
        textView.typingAttributes = attributes
        
        //Update attributes in textStorage
        if let data = state.attributesToApply {
            applyAttributesToSelectedRange(textView, at: data.range, for: data.activeStyles, shouldApply: data.shouldApply)
        }

        textView.reloadInputViews()
    }
    
    internal class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper
        
        init(_ uiTextView: TextViewWrapper) {
            self.parent = uiTextView
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            //Invoked when selection change whether it is text lelected or pointer moved any were
            parent.state.onTextViewEvent(.didChangeSelection(textView))
        }
        
        func textViewDidChange(_ textView: UITextView) {
            if textView.markedTextRange == nil {
                parent.state.editableText = NSMutableAttributedString(attributedString: textView.attributedText)
            }
            parent.state.onTextViewEvent(.didChange(textView))
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            //Invoked when text view start editing (TextView get focuse or become first responder)
            parent.state.onTextViewEvent(.didBeginEditing(textView))
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.state.onTextViewEvent(.didEndEditing(textView))
        }
    }
    
    internal func getTypingAttributesForStyles(_ styles : Set<RichTextStyle>) -> RichTextAttributes {
        var font = fontStyle
        var attributes: RichTextAttributes = [:]
        styles.forEach({
            if $0.attributedStringKey == .font {
                font = font?.addFontStyle($0)
                attributes[$0.attributedStringKey] = font
            } else {
                attributes[$0.attributedStringKey] = $0.defaultAttributeValue
            }
        })
        return attributes
    }
    
    internal func applyAttributesToSelectedRange(_ textView: TextViewOverRidden, at range: NSRange, for styles: [RichTextStyle], shouldApply: Bool = true) {
        if shouldApply {
            styles.forEach { style in
                if style.attributedStringKey == .font {
                    textView.textStorage.setRichTextStyle(style, to: shouldApply, at: range)
                } else {
                    textView.textStorage.addAttribute(style.attributedStringKey, value: style.defaultAttributeValue, range: range)
                }
            }
        } else {
            styles.forEach({ style in
                if style.attributedStringKey == .font {
                    textView.textStorage.setRichTextStyle(style, to: shouldApply, at: range)
                } else {
                    textView.textStorage.removeAttribute(style.attributedStringKey, range: range)
                }
            })
        }
        
        state.activeAttributes = nil
    }
}

//MARK: - TextViewOverRidden
class TextViewOverRidden: UITextView {
    ///https://developer.apple.com/forums/thread/115445
    ///To disable system manu for edit text on text selection
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false //To disable clipboard Manu on text selection
    }
}

//MARK: - TextView Events
public enum TextViewEvents {
    case didChangeSelection(_ textView: UITextView)
    case didBeginEditing(_ textView: UITextView)
    case didChange(_ textView: UITextView)
    case didEndEditing(_ textView: UITextView)
}
