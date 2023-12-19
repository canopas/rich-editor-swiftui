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
    
    @Published var editableText: NSMutableAttributedString
    @Published var currentStyles: Set<TextSpanStyle>
    
    private var spans: [RichTextSpan]
    private var selection: NSRange
    private var rawText: String
    
    @Published var activeSpans: Set<RichTextSpan> = []
    @Published var activeAttributes: [NSAttributedString.Key: Any]? = nil
        
    var richText: RichText {
        return RichText(text: editableText.string, spans: spans)
    }
    
    var previousTextLength: Int = 0
    
    var currentTextLength: Int = 0 {
        willSet {
            if previousTextLength != currentTextLength {
                previousTextLength = currentTextLength
            }
        }
    }
    
    public init(input: String) {
        let adapter = DefaultAdapter()
        self.input = input
        self.adapter = adapter
        
        let richText = input.isEmpty ? RichText() : adapter.encode(input: input)
        editableText = NSMutableAttributedString(string: richText.text)
        spans = richText.spans
        selection = NSRange(location: 0, length: 0)
        currentStyles = []
        rawText = richText.text
        currentTextLength = editableText.length
        previousTextLength = editableText.length
    }
    
    private func getRichText() -> RichText {
        return input.isEmpty ? RichText() : adapter.encode(input: input)
    }
    
    func output() -> String {
        return adapter.decode(editorValue: richText)
    }
    
    func toggleStyle(style: TextSpanStyle) {
        toggleStyle(style)
    }
    
    func updateStyle(style: TextSpanStyle) {
        setStyle(style)
    }
}


extension RichEditorState {
    func onTextViewEvent(_ event: TextViewEvents) {
        switch event {
        case .didChangeSelection(let textView):
            selection = textView.selectedRange
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
    
    func onToolSelection(_ tool: TextSpanStyle) {
        if currentStyles.contains(tool) {
            removeStyle(tool)
        } else {
            addStyle(tool)
        }
    }
    
    func setEditable(editable: NSMutableAttributedString) {
        editable.append(NSMutableAttributedString(string: editable.string))
        self.editableText = editable
        if !editable.string.isEmpty {
            updateText()
        }
    }
    
    private func updateText() {
        editableText.removeAttribute(.font, range: NSRange(location: 0, length: editableText.length))
        editableText.removeAttribute(.foregroundColor, range: NSRange(location: 0, length: editableText.length))
        editableText.removeAttribute(.underlineStyle, range: NSRange(location: 0, length: editableText.length))
        
        spans.forEach {
            var font: UIFont = UIFont()
            var attributes: [NSAttributedString.Key: Any] = [:]
            switch $0.style {
            case .bold:
                font = .boldSystemFont(ofSize: 12)
                attributes[.font] = font
            case .italic:
                font = .italicSystemFont(ofSize: 12)
                attributes[.font] = font
            case .underline:
                attributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
            case .h1:
                font = .systemFont(ofSize: 20)
                attributes[.font] = font
            case .h2:
                font = .systemFont(ofSize: 18)
                attributes[.font] = font
            case .h3:
                font = .systemFont(ofSize: 16)
                attributes[.font] = font
            case .h4:
                font = .systemFont(ofSize: 14)
                attributes[.font] = font
            case .h5:
                font = .systemFont(ofSize: 12)
                attributes[.font] = font
            case .h6:
                font = .systemFont(ofSize: 10)
                attributes[.font] = font
            case .default:
                return
            }
            
            editableText.addAttributes(attributes, range: NSRange(location: $0.from, length: ($0.to - $0.from)))
        }
                
        updateCurrentSpanStyle()
    }
    
    private func updateCurrentSpanStyle() {
        guard !selection.collapsed && selection.lowerBound != 0 else {
            return
        }
        
        currentStyles.removeAll()
        
        if selection.collapsed {
            let currentStyles = getRichSpanStyleByTextIndex(textIndex: selection.lowerBound)
            self.currentStyles.formUnion(currentStyles)
        } else {
            let currentStyles = getRichSpanStyleListByTextRange(selection)
            self.currentStyles.formUnion(currentStyles)
        }
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
    
    func toggleStyle(_ style: TextSpanStyle) {
        if currentStyles.contains(style) {
            removeStyle(style)
        } else {
            addStyle(style)
        }
    }
    
    private func removeStyle(_ style: TextSpanStyle) {
        currentStyles.remove(style)
        
        guard !selection.collapsed else {
            return
        }
        
        let fromIndex = selection.lowerBound
        let toIndex = selection.upperBound
        
        let selectedParts = spans.filter({ ($0.from...$0.to).overlaps((fromIndex...toIndex))
            && $0.style == style })
        
        removeStylesFromSelectedPart(selectedParts, fromIndex: fromIndex, toIndex: toIndex)
        updateText()
    }
    
    private func addStyle(_ style: TextSpanStyle) {
        currentStyles.insert(style)
        
        if (style.isHeaderStyle || style.isDefault) && !selection.collapsed {
            handleAddHeaderStyle(style)
        }
        
        if !selection.collapsed {
            applyStylesToSelectedText(style)
        }
    }
    
    private func handleAddHeaderStyle(_ style: TextSpanStyle) {
        guard !rawText.isEmpty else {
            return
        }
        
        let fromIndex = selection.lowerBound
        let toIndex = selection.collapsed ? fromIndex : selection.upperBound
        
        let startIndex = 0 //rawText.prefix(fromIndex).index(before: <#T##Substring.Index#>) max(0, rawText.lastIndex(of: "\n", before: fromIndex) ?? rawText.startIndex)
        var endIndex = 0 //rawText.firstIndex(of: "\n", after: toIndex) ?? rawText.index(before: rawText.endIndex)
        
        if endIndex == (rawText.count - 1) {
            //            endIndex = rawText.index(before: endIndex)
        }
        
        let selectedParts = spans.filter { (($0.from...$0.to).overlaps(fromIndex...toIndex))
            && $0.style.isHeaderStyle }
        
        spans.removeAll(where: { selectedParts.contains($0) })
        
        spans.append(RichTextSpan(from: startIndex, to: endIndex, style: style))
        updateText()
    }
    
    private func removeStylesFromSelectedPart(_ selectedParts: [RichTextSpan], fromIndex: Int, toIndex: Int) {
        selectedParts.forEach { part in
            if let index = spans.firstIndex(of: part) {
                if part.from < fromIndex && part.to >= toIndex {
                    spans[index] = RichTextSpan(from: part.from, to: fromIndex, style: part.style)
                    spans.insert(RichTextSpan(from: toIndex, to: part.to, style: part.style), at: index + 1)
                } else if part.from < fromIndex {
                    spans[index] = RichTextSpan(from: part.from, to: fromIndex, style: part.style)
                } else if part.to > toIndex {
                    spans[index] = RichTextSpan(from: toIndex, to: part.to, style: part.style)
                } else {
                    spans.remove(at: index)
                }
            }
        }
    }
    
    private func applyStylesToSelectedText(_ style: TextSpanStyle) {
        guard !selection.collapsed else {
            return
        }
        
        let fromIndex = selection.lowerBound
        let toIndex = selection.upperBound
        
        let selectedParts = spans.filter({ (($0.from...$0.to).overlaps(fromIndex...toIndex )) })
        
        let startParts = spans.filter { $0.from == fromIndex }
        let endParts = spans.filter { $0.to == toIndex + 1 }
        
        if startParts.isEmpty && endParts.isEmpty && !selectedParts.isEmpty {
            spans.append(RichTextSpan(from: fromIndex, to: toIndex, style: style))
        } else if startParts.contains(where: { $0.style == style }) {
            startParts.filter { $0.style == style }.forEach { part in
                if let index = spans.firstIndex(of: part) {
                    spans[index] = RichTextSpan(from: part.from, to: toIndex, style: part.style)
                }
            }
        } else if endParts.contains(where: { $0.style == style }) {
            endParts.filter { $0.style == style }.forEach { part in
                if let index = spans.firstIndex(of: part) {
                    spans[index] = RichTextSpan(from: fromIndex, to: part.to, style: part.style)
                }
            }
        } else {
            spans.append(RichTextSpan(from: fromIndex, to: toIndex, style: style))
        }
        
        updateText()
    }
    
    func setStyle(_ style: TextSpanStyle) {
        currentStyles.removeAll()
        currentStyles.insert(style)
        
        if style.isHeaderStyle || style.isDefault {
            handleAddHeaderStyle(style)
            return
        }
        
        if !selection.collapsed {
            applyStylesToSelectedText(style)
        }
    }
    
    func onTextFieldValueChange(newText: NSMutableAttributedString, selection: NSRange) {
        self.selection = selection
        
        if newText.length > rawText.count {
            handleAddingCharacters(newText)
        } else if newText.length < rawText.count {
            handleRemovingCharacters(newText)
        }
        
        rawText = newText.string
        updateText()
    }
    
    private func handleAddingCharacters(_ newValue: NSMutableAttributedString) {
        let typedChars = newValue.length - rawText.count
        let startTypeIndex = selection.location - typedChars
        let startTypeChar = newValue.string[startTypeIndex]
        
        if startTypeChar == "\n",
           currentStyles.contains(where: { $0.isHeaderStyle }) {
            currentStyles.removeAll()
        }
        
        var selectedStyles = currentStyles
        
        moveSpans(startTypeIndex: startTypeIndex, by: typedChars)
        
        let startParts = spans.filter { ($0.from...$0.to).contains(startTypeIndex - 1) }
        let endParts = spans.filter { ($0.from...$0.to).contains(startTypeIndex) }
        let commonParts = Set(startParts).intersection(Set(endParts))
        
        startParts.filter { !commonParts.contains($0) }.forEach { part in
            if selectedStyles.contains(part.style) {
                if let index = spans.firstIndex(of: part) {
                    spans[index] = RichTextSpan(from: part.from, to: part.to + typedChars, style: part.style)
                    selectedStyles.remove(part.style)
                }
            }
        }
        
        endParts.filter { !commonParts.contains($0) }.forEach { part in
            processSpan(part, typedChars: typedChars, startTypeIndex: startTypeIndex, selectedStyles: &selectedStyles, forward: true)
        }
        
        commonParts.forEach { part in
            processSpan(part, typedChars: typedChars, startTypeIndex: startTypeIndex, selectedStyles: &selectedStyles)
        }
        
        selectedStyles.forEach { style in
            spans.append(RichTextSpan(from: startTypeIndex, to: startTypeIndex + typedChars - 1, style: style))
        }
    }
    
    private func processSpan(_ richTextSpan: RichTextSpan, typedChars: Int, startTypeIndex: Int, selectedStyles: inout Set<TextSpanStyle>, forward: Bool = false) {
        let newFromIndex = richTextSpan.from + typedChars
        let newToIndex = richTextSpan.to + typedChars
        
        if let index = spans.firstIndex(of: richTextSpan) {
            if selectedStyles.contains(richTextSpan.style) {
                spans[index] = RichTextSpan(from: richTextSpan.from, to: newToIndex, style: richTextSpan.style)
                selectedStyles.remove(richTextSpan.style)
            } else {
                if forward {
                    spans[index] = RichTextSpan(from: richTextSpan.from, to: newToIndex, style: richTextSpan.style)
                } else {
                    spans[index] = RichTextSpan(from: richTextSpan.from, to: startTypeIndex - 1, style: richTextSpan.style)
                    spans.insert(RichTextSpan(from: startTypeIndex + typedChars, to: newToIndex, style: richTextSpan.style), at: index + 1)
                    selectedStyles.remove(richTextSpan.style)
                }
            }
        }
    }
    
    private func moveSpans(startTypeIndex: Int, by step: Int) {
        let filteredSpans = spans.filter { $0.from > startTypeIndex }
        
        filteredSpans.forEach { part in
            if let index = spans.firstIndex(of: part) {
                spans[index] = RichTextSpan(from: part.from + step, to: part.to + step, style: part.style)
            }
        }
    }
    
    private func handleRemovingCharacters(_ newText: NSMutableAttributedString) {
        guard !newText.string.isEmpty else {
            spans.removeAll()
            currentStyles.removeAll()
            return
        }
                
        let removedCharsCount = rawText.count - newText.string.count
        let startRemoveIndex = selection.lowerBound
        let endRemoveIndex = selection.lowerBound + removedCharsCount
        let removeRange = startRemoveIndex ..< endRemoveIndex
        let start = rawText.index(rawText.startIndex, offsetBy: startRemoveIndex)
        let end = rawText.index(rawText.startIndex, offsetBy: endRemoveIndex - 1)

        if let newLineIndex = rawText[start...end].firstIndex(of: "\n") {
            handleRemoveHeaderStyle(newText: newText, removeRange: removeRange, newLineIndex: newLineIndex)
        }
        
        let partsCopy = spans
        
        for part in partsCopy {
            if let index = partsCopy.firstIndex(of: part) {
                if removeRange.upperBound < part.from {
                    spans[index] = RichTextSpan(from: part.from - removedCharsCount, to: part.to - removedCharsCount, style: part.style)
                } else if removeRange.lowerBound <= part.from && removeRange.upperBound >= part.to {
                    // Remove the element from the copy.
                    spans.remove(at: index)
                } else if removeRange.lowerBound <= part.from {
                    spans[index] = RichTextSpan(from: max(0, removeRange.lowerBound), to: min(newText.length, part.to - removedCharsCount), style: part.style)
                } else if removeRange.upperBound <= part.to {
                    spans[index] = RichTextSpan(from: part.from, to: part.to - removedCharsCount, style: part.style)
                } else if removeRange.lowerBound < part.to {
                    spans[index] = RichTextSpan(from: part.from, to: removeRange.lowerBound, style: part.style)
                }
            }
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
        updateText()
    }
    
    func adjustSelection(selection: NSRange) {
        if self.selection != selection {
            self.selection = selection
            updateCurrentSpanStyle()
        }
    }
    
    func hasStyle(style: TextSpanStyle) -> Bool {
        return currentStyles.contains(style)
    }
    
    func reset() {
        spans.removeAll()
        rawText = ""
        editableText = NSMutableAttributedString(string: "")
        updateText()
    }
}