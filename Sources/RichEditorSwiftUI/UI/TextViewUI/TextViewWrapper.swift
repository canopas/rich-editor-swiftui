//
//  TextViewWrapper.swift
//
//
//  Created by Divyesh Vekariya on 12/10/23.
//

import SwiftUI

internal struct TextViewWrapper: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var state: RichEditorState

    @Binding private var typingAttributes: [NSAttributedString.Key: Any]?
    @Binding private var attributesToApply: ((spans: [(span:RichTextSpanInternal, shouldApply: Bool)], onCompletion: () -> Void))?

    private let isEditable: Bool
    private let isUserInteractionEnabled: Bool
    private let isScrollEnabled: Bool
    private let linelimit: Int?
    private let fontStyle: FontRepresentable?
    private var _fontColor: Color? = nil
    private var _backGroundColor: UIColor? = nil
    private let tag: Int?
    private let onTextViewEvent: ((TextViewEvents) -> Void)?

    private var fontColor: Color {
        if let _fontColor {
            return _fontColor
        } else {
            return colorScheme == .dark ? .white : .black
        }
    }

    private var backGroundColor: UIColor {
        if let _backGroundColor {
            return _backGroundColor
        } else {
            return colorScheme == .dark ? .gray.withAlphaComponent(0.3) : .white
        }
    }

    private var textPadding: CGFloat? = nil

    public init(state: ObservedObject<RichEditorState>,
                typingAttributes: Binding<[NSAttributedString.Key: Any]?>? = nil,
                attributesToApply: Binding<(spans: [(span:RichTextSpanInternal, shouldApply: Bool)], onCompletion: () -> Void)?>? = nil,
                isEditable: Bool = true,
                isUserInteractionEnabled: Bool = true,
                isScrollEnabled: Bool = false,
                linelimit: Int? = nil,
                fontStyle: FontRepresentable? = nil,
                fontColor: Color? = nil,
                backGroundColor: Color? = nil,
                tag: Int? = nil,
                textPadding: CGFloat? = nil,
                onTextViewEvent: ((TextViewEvents) -> Void)?) {

        self._state = state
        self._typingAttributes = typingAttributes != nil ? typingAttributes! : .constant(nil)
        self._attributesToApply = attributesToApply != nil ? attributesToApply! : .constant(nil)

        self.isEditable = isEditable
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.isScrollEnabled = isScrollEnabled
        self.linelimit = linelimit
        self.fontStyle = fontStyle
        if let fontColor {
            self._fontColor = fontColor
        }
        if let backGroundColor {
            self._backGroundColor = UIColor(backGroundColor)
        }
        self.tag = tag
        self.textPadding = textPadding ?? 0
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
        if let fontStyle {
            textView.typingAttributes = [.font: fontStyle]
        }
        if let fontStyle {
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
        textView.backgroundColor = backGroundColor
        if let textPadding {
            textView.contentInset = UIEdgeInsets(top: textPadding, left: textPadding, bottom: textPadding, right: textPadding)
        }

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
        textView.textColor = UIColor(fontColor)
        textView.backgroundColor = backGroundColor
        ///Set typing attributes
        var attributes = getTypingAttributesForStyles(state.activeStyles)
        if !attributes.contains(where: { $0.key == .font }) {
            attributes[.font] = fontStyle
        }
        if textView.typingAttributes.contains(where: { $0.key == .paragraphStyle }) && attributes.contains(where: { $0.key == .paragraphStyle }) {
            if let paragraphToSet = textView.typingAttributes[.paragraphStyle] as? NSMutableParagraphStyle, let paragraphGot = attributes[.paragraphStyle] as? NSMutableParagraphStyle, paragraphToSet.textLists.count != paragraphGot.textLists.count {
                let paragraph = paragraphGot.mutableCopy() as? NSMutableParagraphStyle
                paragraph?.textLists = paragraphToSet.textLists.isEmpty ? paragraphGot.textLists : paragraphToSet.textLists
                attributes[.paragraphStyle] = paragraph
            }

        } else if textView.typingAttributes.contains(where: { $0.key != .paragraphStyle }) && attributes.contains(where: { $0.key == .paragraphStyle }) {
            if let style = state.activeStyles.first(where: { $0.isList }) {
                let isCursorAtEnd = textView.selectedRange.location == textView.text.utf16Length
                if isCursorAtEnd {
                    textView.textStorage.replaceCharacters(in: textView.selectedRange, with: "\n")
                }
                textView.textStorage.setRichTextStyle(style, to: true, at: .init(location: max(0, textView.selectedRange.location), length: 1))
            }
        } else if textView.typingAttributes.contains(where: { $0.key == .paragraphStyle }) && attributes.contains(where: { $0.key != .paragraphStyle }) {
            textView.textStorage.setRichTextStyle(.bullet(0), to: false, at: .init(location: textView.selectedRange.location, length: 1))
        }
        textView.typingAttributes = attributes

        //Update attributes in textStorage
        if let data = attributesToApply {
            applyAttributesToSelectedRange(textView, spans: data.spans, onCompletion: data.onCompletion)
        }
    }

    internal class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper

        init(_ uiTextView: TextViewWrapper) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return parent.state.textView(textView, shouldChangeTextIn: range, replacementText: text)
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            //Invoked when selection change whether it is text selected or pointer moved any were
            parent.onTextViewEvent?(.didChangeSelection(textView))
        }

        func textViewDidChange(_ textView: UITextView) {
            if textView.markedTextRange == nil {
                parent.state.editableText = NSMutableAttributedString(attributedString: textView.attributedText)
            }
            parent.onTextViewEvent?(.didChange(textView))
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            //Invoked when text view start editing (TextView get focused or become first responder)
            parent.onTextViewEvent?(.didBeginEditing(textView))
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            parent.onTextViewEvent?(.didEndEditing(textView))
        }
    }

    internal func getTypingAttributesForStyles(_ styles : Set<RichTextStyle>) -> RichTextAttributes {
        var font = fontStyle
        var attributes: RichTextAttributes = [:]

        Set(styles).forEach({
            if $0.attributedStringKey == .font {
                font = $0.getFontWithUpdating(font: font ?? .systemFont(ofSize: .standardRichTextFontSize))
                attributes[$0.attributedStringKey] = font
            } else {
                attributes[$0.attributedStringKey] = $0.defaultAttributeValue(font: fontStyle)
            }
        })
        if !attributes.contains(where: { $0.key == .paragraphStyle }) {
            attributes[.paragraphStyle] = nil
        }
        return attributes
    }

    internal func applyAttributesToSelectedRange(_ textView: TextViewOverRidden, spans: [(span:RichTextSpanInternal, shouldApply: Bool)], onCompletion: (() -> Void)? = nil) {
        var spansToUpdate = spans.filter({ $0.span.attributes?.header != nil })
        spansToUpdate.append(contentsOf: spans.filter({ $0.span.attributes?.header == nil }))
        spansToUpdate.forEach { span in
            span.span.attributes?.styles().forEach({ style in
                textView.textStorage.setRichTextStyle(style, to: span.shouldApply, at: span.span.spanRange)
            })
        }
        onCompletion?()
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
