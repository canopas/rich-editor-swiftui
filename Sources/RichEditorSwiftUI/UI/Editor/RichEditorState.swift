//
//  RichEditorState.swift
//
//
//  Created by Divyesh Vekariya on 11/12/23.
//


import Foundation
import UIKit

public class RichEditorState: ObservableObject {
    private let input: String
    private var adapter: EditorAdapter = DefaultAdapter()
    
    @Published internal var editableText: NSMutableAttributedString
    @Published internal var activeStyles: Set<TextSpanStyle> = []
    @Published internal var activeAttributes: [NSAttributedString.Key: Any]? = [:]
    
    @Published internal var attributesToApply: (attributes: [NSAttributedString.Key: Any], range: NSRange, shouldApply: Bool)? = nil
    
    private var spans: [RichTextSpan]
    private var selection: NSRange
    private var rawText: String
    
    public var richText: RichText {
        return getRichText()
    }
    
    public init(input: String, spans: [RichTextSpan] = []) {
        let adapter = DefaultAdapter()
        self.input = input
        self.adapter = adapter
        
        let richText = input.isEmpty ? RichText() : adapter.encode(input: input, spans: spans)
        editableText = NSMutableAttributedString(string: richText.text)
        self.spans = richText.spans
        
        selection = NSRange(location: 0, length: 0)
        activeStyles = []
        
        rawText = richText.text
    }
    
    private func getRichText() -> RichText {
        return input.isEmpty ? RichText() : adapter.encode(input: input, spans: getSpansFromAttributedText(editableText))
    }
    
    public func output() -> String {
        return adapter.decode(editorValue: richText)
    }
    
    public func toggleStyle(style: TextSpanStyle) {
        toggleStyle(style)
    }
    
    public func updateStyle(style: TextSpanStyle) {
        setStyle(style)
    }
}


extension RichEditorState {
    internal func onTextViewEvent(_ event: TextViewEvents) {
        switch event {
        case .didChangeSelection(let textView):
            guard rawText.length == textView.attributedText.length else { return }
            onSelectionChanged(textView.selectedRange)
        case .didBeginEditing(let textView):
            selection = textView.selectedRange
            return
        case .didChange(let textView):
            onTextFieldValueChange(newText: editableText, selection: selection)
            return
        case .didEndEditing:
            selection = .init(location: 0, length: 0)
            return
        }
    }
    
    internal func onToolSelection(_ tool: TextSpanStyle) {
        toggleStyle(tool)
    }
    
    private func setStyle(_ style: TextSpanStyle) {
        activeStyles.removeAll()
        activeStyles.insert(style)
        
        if style.isHeaderStyle || style.isDefault {
            handleAddHeaderStyle(style)
            return
        }
        
        if !selection.collapsed {
            applyStylesToSelectedText(style, range: selection)
        }
    }
    
    private func setEditable(editable: NSMutableAttributedString) {
        editable.append(NSMutableAttributedString(string: editable.string))
        self.editableText = editable
    }
    
    private func getRichSpanStyleByTextIndex(textIndex: Int) -> Set<TextSpanStyle> {
        let styles = Set(spans.filter { textIndex >= $0.from && textIndex <= $0.to }.map { $0.style })
        return styles
    }
    
    private func getRichSpanStyleListByTextRange(_ range: NSRange) -> [TextSpanStyle] {
        return spans.filter({ ($0.from...$0.to).overlaps(range.lowerBound...range.upperBound) }).map { $0.style }
    }
    
    private func getRichSpansByTextIndex(_ index: Int) -> [RichTextSpan] {
        return spans.filter({ ($0.from...$0.to).contains(index) })
    }
    
    private func getRichSpanListByTextRange(_ range: NSRange) -> [RichTextSpan] {
        return spans.filter({ ($0.from...$0.to).overlaps(range.lowerBound...range.upperBound) })
    }
    
    private func onSelectionChanged(_ range: NSRange) {
        guard !editableText.string.isEmpty else { return }
        selection = range
        var newStyles: Set<TextSpanStyle> = []
        
        if selection.collapsed {
            if selection.location == 0 {
                newStyles = Set(getSpansFromAttributedText(editableText, forRange: .init(location: selection.location, length: 1)).map({ $0.style }))
            } else {
                if editableText.length >= selection.location {
                    newStyles = Set(getSpansFromAttributedText(editableText, forRange: .init(location: (selection.location - 1), length: 1)).map({ $0.style }))
                }
            }
        } else {
            newStyles = Set(getSpansFromAttributedText(editableText, forRange: selection).map({ $0.style }))
        }
        
        guard activeStyles != newStyles else { return }
        
        if selection.location == (editableText.length + 1) && !activeStyles.isEmpty && newStyles.isEmpty {
            var attributes: [NSAttributedString.Key: Any] = [:]
            activeStyles.forEach({
                attributes[$0.attributedStringKey] = $0.attributeValue
            })
            
            activeAttributes = attributes
        } else {
            activeStyles = newStyles
            var attributes: [NSAttributedString.Key: Any] = [:]
            activeStyles.forEach({
                attributes[$0.attributedStringKey] = $0.attributeValue
            })
            
            activeAttributes = attributes
        }
    }
    
    private func toggleStyle(_ style: TextSpanStyle) {
        if activeStyles.contains(style) {
            removeStyle(style)
        } else {
            addStyle(style)
        }
    }
    
    
    private func onTextFieldValueChange(newText: NSMutableAttributedString, selection: NSRange) {
        self.selection = selection
        
        if newText.length > rawText.count {
            handleAddingCharacters(newText)
        } else if newText.length < rawText.count {
            handleRemovingCharacters(newText)
        }
        
        rawText = newText.string
    }
    
    private func handleAddHeaderStyle(_ style: TextSpanStyle) {
        guard !rawText.isEmpty else {
            return
        }
        
        let fromIndex = selection.lowerBound
        let toIndex = selection.collapsed ? fromIndex : selection.upperBound
        
        let startIndex = 0 //rawText.prefix(fromIndex).index(before: 0) max(0, rawText.lastIndex(of: "\n", before: fromIndex) ?? rawText.startIndex)
        var endIndex = 0 //rawText.firstIndex(of: "\n", after: toIndex) ?? rawText.index(before: rawText.endIndex)
        
        if endIndex == (rawText.count - 1) {
            //            endIndex = rawText.index(before: endIndex)
        }
        
        /// Handle adding header attributes to the editable
    }
    //MARK: - Add styles
    private func addStyle(_ style: TextSpanStyle) {
        guard !activeStyles.contains(style) else { return }
        activeStyles.insert(style)
        
        if !selection.collapsed {
            applyStylesToSelectedText(style, range: selection)
        }
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        activeStyles.forEach({
            attributes[$0.attributedStringKey] = $0.attributeValue
        })
        
        activeAttributes = attributes
    }
    
    private func applyStylesToSelectedText(_ style: TextSpanStyle, range: NSRange) {
        guard !range.collapsed else { return }
        attributesToApply = (attributes: [style.attributedStringKey: style.attributeValue], range: range, shouldApply: true)
    }
    
    private func handleAddingCharacters(_ newValue: NSMutableAttributedString) {
        let typedChars = newValue.length - rawText.count
        let startTypeIndex = selection.location - typedChars
        let startTypeChar = newValue.string[startTypeIndex]
        
        if startTypeChar == "\n",
           activeStyles.contains(where: { $0.isHeaderStyle }) {
            activeStyles.removeAll()
        }
        print("==== active styles are \(activeStyles.map({ $0.rawValue })), and attributes are \(activeAttributes?.count)")
    }
    
    //MARK: - Remove Style
    private func removeStyle(_ style: TextSpanStyle) {
        guard activeStyles.contains(style) else { return }
        activeStyles.remove(style)
        removeStylesAndTypingAttributes()
        removeAttributes(style)
    }
    
    private func removeStylesAndTypingAttributes() {
        let location = selection.location
        let activeSpans = spans.filter({ ($0.from...$0.to).contains(location) })
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        activeStyles.forEach({
            attributes[$0.attributedStringKey] = $0.attributeValue
        })
        
        activeAttributes = attributes
    }
    
    private func removeAttributes(_ style: TextSpanStyle) {
        guard !selection.collapsed else { return }
        attributesToApply = (attributes: [style.attributedStringKey: style.attributeValue], range: selection, shouldApply: false)
    }
    
    private func handleRemovingCharacters(_ newText: NSMutableAttributedString) {
        guard !newText.string.isEmpty else {
            spans.removeAll()
            activeStyles.removeAll()
            return
        }
    }
    
    private func handleRemoveHeaderStyle(newText: NSMutableAttributedString, removeRange: Range<Int>, newLineIndex: String.Index) {
        let fromIndex = selection.lowerBound
        let toIndex = selection.upperBound
        
        let startIndex = max(newText.string.startIndex, newText.string.index(before: newLineIndex))
        let endIndex = newText.string.index(after: newLineIndex)
        
        let selectedParts = spans.filter({ ((($0.from...$0.to).overlaps(fromIndex...toIndex))
                                            && $0.style.isHeaderStyle) })
        
        spans.removeAll(where: { selectedParts.contains($0) })
        
        spans.append(RichTextSpan(from: startIndex.utf16Offset(in: newText.string), to: endIndex.utf16Offset(in: newText.string) - 1, style: .h1))
    }
}

//MARK: - Helper Methods
extension RichEditorState {
    public func reset() {
        spans.removeAll()
        rawText = ""
        editableText = NSMutableAttributedString(string: "")
    }
}

//MARK: AttibutedTextProcecure
extension RichEditorState {
    
    func getSpansFromAttributedText(_ text: NSMutableAttributedString, forRange range: NSRange? = nil, forStyles styles: [TextSpanStyle] = TextSpanStyle.allCases) -> [RichTextSpan] {
        var spans: [RichTextSpan] = []
        styles.forEach({ style in
            switch style {
            case .bold:
                spans.append(contentsOf: getSpanForBold(text, forRange: range))
            case .italic:
                spans.append(contentsOf: [])
            case .underline:
                spans.append(contentsOf: [])
            case .h1:
                spans.append(contentsOf: [])
            case .h2:
                spans.append(contentsOf: [])
            case .h3:
                spans.append(contentsOf: [])
            case .h4:
                spans.append(contentsOf: [])
            case .h5:
                spans.append(contentsOf: [])
            case .h6:
                spans.append(contentsOf: [])
            default:
                print("match not found")
            }
        })
        
        return spans
    }
    
    func getSpanForBold(_ text: NSMutableAttributedString, forRange range: NSRange? = nil) -> [RichTextSpan] {
        var spans: [RichTextSpan] = []
        text.enumerateAttribute(.font, in: range == nil ? NSRange(location: 0, length: text.length) : range!, options: []) { (value, range, _) in
            if let font = value as? UIFont {
                if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    spans.append(RichTextSpan(from: range.location, to: range.location + range.length, style: .bold))
                }
            }
        }
        return spans
    }
}

