//
//  TextViewWrapper.swift
//  
//
//  Created by Divyesh Vekariya on 12/10/23.
//

import SwiftUI

internal struct TextViewWrapper: UIViewRepresentable {
    
    @Binding private var text: NSMutableAttributedString
    @Binding private var typingAttributes: [NSAttributedString.Key : Any]?
    
    private let isEditable: Bool
    private let isUserInteractionEnabled: Bool
    private let isScrollEnabled: Bool
    private let linelimit: Int?
    private let fontStyle: UIFont?
    private let fontColor: Color
    private let backGroundColor: UIColor
    private let tag: Int?
    private let onTextViewEvent: ((TextViewEvents) -> Void)?
    
    public init(text: Binding<NSMutableAttributedString>,
                typingAttributes: Binding<[NSAttributedString.Key : Any]?>? = nil,
                isEditable: Bool = true,
                isUserInteractionEnabled: Bool = true,
                isScrollEnabled: Bool = false,
                linelimit: Int? = nil,
                fontStyle: UIFont? = nil,
                fontColor: Color = .black,
                backGroundColor: UIColor = .clear,
                tag: Int? = nil,
                onTextViewEvent: ((TextViewEvents) -> Void)? = nil) {
        self._text = text
        self._typingAttributes = typingAttributes != nil ? typingAttributes! : .constant(nil)
        
        self.isEditable = isEditable
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.isScrollEnabled = isScrollEnabled
        self.linelimit = linelimit
        self.fontStyle = fontStyle
        self.fontColor = fontColor
        self.backGroundColor = backGroundColor
        self.tag = tag
        self.onTextViewEvent = onTextViewEvent
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
        textView.attributedText = text
        textView.textColor = UIColor(fontColor)
        textView.textContainer.lineFragmentPadding = 0
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isSelectable = true
        
        if let attributes = typingAttributes {
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
        // Record where the cursor is
        var cursorOffset: Int?
        if let selectedRange = textView.selectedTextRange {
            cursorOffset = textView.offset(from: textView.beginningOfDocument, to: selectedRange.end)
        }
        
        // Update the field (this will displace the cursor)
        if textView.attributedText != text {
            textView.attributedText = text
        }
        textView.textColor = UIColor.black
        textView.typingAttributes = typingAttributes ?? [:]
        
//        if let fontStyle = fontStyle {
//            let scaledFontSize = UIFontMetrics.default.scaledValue(for: fontStyle.pointSize)
//            let scaledFont = fontStyle.withSize(scaledFontSize)
//            textView.font = scaledFont
//        }
        
        // Put the cursor back
        if let offset = cursorOffset,
           let position = textView.position(from: textView.beginningOfDocument, offset: offset) {
            textView.selectedTextRange = textView.textRange(from: position, to: position)
        }
        textView.reloadInputViews()
    }
    
    public class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper
        
        init(_ uiTextView: TextViewWrapper) {
            self.parent = uiTextView
        }
        
        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        public func textViewDidChangeSelection(_ textView: UITextView) {
            //Invoked when selection change whether it is text lelected or pointer moved any where
            parent.onTextViewEvent?(.didChangeSelection(textView))
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            if textView.markedTextRange == nil {
                parent.text = NSMutableAttributedString(attributedString: textView.attributedText)
            }
            parent.onTextViewEvent?(.didChange(textView))
        }
        
        public func textViewDidBeginEditing(_ textView: UITextView) {
            //Invoked when text view start editing (TextView get focuse or become first responder)
            parent.onTextViewEvent?(.didBeginEditing(textView))
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            parent.onTextViewEvent?(.didEndEditing(textView))
        }
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
