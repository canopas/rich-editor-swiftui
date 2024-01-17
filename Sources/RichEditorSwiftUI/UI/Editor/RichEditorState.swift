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
    internal var curretFont: FontRepresentable = .systemFont(ofSize: .standardRichTextFontSize)
    
    @Published internal var attributesToApply: ((spans: [(span:RichTextSpan, shouldApply: Bool)], onCompletion: () -> Void))? = nil
    
    private var spans: [RichTextSpan]
    private var highlightedRange: NSRange
    private var rawText: String
    
    private var updateAttributesQueue: [(span:RichTextSpan, shouldApply: Bool)] = []
    
    /**
     This will provide encoded text which is of type RichText
     */
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
        
        highlightedRange = NSRange(location: 0, length: 0)
        activeStyles = []
        
        rawText = richText.text
        setUpSpans()
    }
    
    /**
     This will provide RichText which is encoded from input and editor text
     */
    private func getRichText() -> RichText {
        return input.isEmpty ? RichText() : adapter.encode(input: input, spans: spans)
    }
    
    /**
     This will provide String value from editor
     */
    public func output() -> String {
        return adapter.decode(editorValue: richText)
    }
    
    /**
     This will toggle the style
     - Parameters:
     - style: is of type TextSpanStyle
     */
    public func toggleStyle(style: TextSpanStyle) {
        toggleStyle(style)
    }
    
    /**
     This will update the style
     - Parameters:
     - style: is of type TextSpanStyle
     */
    public func updateStyle(style: TextSpanStyle) {
        setStyle(style)
    }
    
    /**
     This will setup edittor according to pasns provided in init
     */
    private func setUpSpans() {
        applyStylesToSelectedText(spans)
    }
}


extension RichEditorState {
    /**
     Handle UITextView's delegate methods calles
     - Parameters:
     - event: is of type TextVIewEvents
     This will switch on event and call respective method
     */
    internal func onTextViewEvent(_ event: TextViewEvents) {
        switch event {
        case .didChangeSelection(let textView):
            highlightedRange = textView.selectedRange
            guard rawText.count == textView.attributedText.string.count && highlightedRange.isCollapsed else { return }
            onSelectionChanged(textView.selectedRange, newText: NSMutableAttributedString(attributedString: textView.attributedText))
        case .didBeginEditing(let textView):
            highlightedRange = textView.selectedRange
        case .didChange:
            onTextFieldValueChange(newText: editableText, selection: highlightedRange)
        case .didEndEditing:
            highlightedRange = .init(location: 0, length: 0)
        }
    }
    
    /**
     This medo will decide whether Charater is added or removed and perfom accordingly
     - Parameters:
     - newText: is updated NSMutableAttributedString
     - selection: is the range of the selected text
     */
    private func onTextFieldValueChange(newText: NSMutableAttributedString, selection: NSRange) {
        self.highlightedRange = selection
        
        if newText.string.count > rawText.count {
            handleAddingCharacters(newText)
        } else if newText.string.count < rawText.count {
            handleRemovingCharacters(newText)
        }
        
        rawText = newText.string
        updateCurrentSpanStyle()
    }
    
    /**
     Update the selection
     - Parameters:
     - range: is the range of the selected text
     - newText: is updated NSMutableAttributedString
     */
    internal func onSelectionChanged(_ range: NSRange, newText: NSMutableAttributedString) {
        highlightedRange = range
        updateCurrentSpanStyle()
    }
    
    /**
     Set the activeStyles
     - Parameters:
     - style: is of type TextSpanStyle
     This will set the activeStyle accordig to style  passed
     */
    private func setStyle(_ style: TextSpanStyle) {
        activeStyles.removeAll()
        activeStyles.insert(style)
        
        if style.isHeaderStyle || style.isDefault {
            handleAddHeaderStyle(style)
        } else if !highlightedRange.isCollapsed {
            let span = RichTextSpan(from: highlightedRange.lowerBound, to: highlightedRange.upperBound - 1, style: style)
            applyStylesToSelectedText([span])
            if !style.isDefault {
                createSpanForSelectedText(style)
            }
        }
        
        updateCurrentSpanStyle()
    }
    
    /**
     Update the activeStyles and activeAttibutes
     */
    private func updateCurrentSpanStyle() {
        guard !editableText.string.isEmpty else { return }
        var newStyles: Set<TextSpanStyle> = []
        
        if highlightedRange.isCollapsed {
            newStyles = getRichSpanStyleByTextIndex(highlightedRange.location - 1)
        } else {
            newStyles =  Set(getRichSpanStyleListByTextRange(highlightedRange))
        }
        
        guard activeStyles != newStyles && highlightedRange.location != 0 else { return }
        activeStyles = newStyles
        var attributes: [NSAttributedString.Key: Any] = [:]
        activeStyles.forEach({
            attributes[$0.attributedStringKey] = $0.defaultAttributeValue(font: curretFont)
        })
        
        activeAttributes = attributes
    }
    
    /**
     This will take style in argument and Toggle it
     - Parameters:
     - style: which is of type TextSpanStyle
     It will add style if not in activeStyle or remove is it is.
     */
    private func toggleStyle(_ style: TextSpanStyle) {
        if activeStyles.contains(style) {
            removeStyle(style)
        } else {
            addStyle(style)
        }
    }
    
    //MARK: - Add styles
    
    /**
     This will add style to the selected text
     - Parameters:
     - style: which is of type TextSpanStyle
     It will add style to the selected text if needed and set activeAttributes and activeStyle accordingly.
     */
    private func addStyle(_ style: TextSpanStyle) {
        guard !activeStyles.contains(style) else { return }
        activeStyles.insert(style)
        
        if (style.isHeaderStyle || style.isDefault) {
            handleAddHeaderStyle(style)
        } else if !highlightedRange.isCollapsed {
            let fromIndex = highlightedRange.location
            let toIdex = highlightedRange.upperBound - 1
            applyStylesToSelectedText([RichTextSpan(from: fromIndex, to: toIdex, style: style)])
            createSpanForSelectedText(style)
        }
    }
    
    /**
     This will add style to the range of text
     - Parameters:
     - style: which is of type TextSpanStyle
     - range: is the range of the text on which you want to apply the style
     */
    private func applyStylesToSelectedText(_ spans: [RichTextSpan]) {
        updateAttributes(spans: spans.map({ ($0, true) }))
    }
    
    /**
     This will update editor text according to span provided in  argument
     - Parameters:
     - spans: Which is of type Tuple of  RichTextSpan and Bool
     
     Where Bool is indicate wheter this style is need to add or remove.
     */
    private func updateAttributes(spans: [(RichTextSpan, shouldApply: Bool)]) {
        if attributesToApply == nil {
            attributesToApply = (spans: spans, onCompletion: { [weak self] in
                self?.attributesToApply = nil
                if let updateQueue = self?.updateAttributesQueue, !updateQueue.isEmpty {
                    self?.updateAttributes(spans: updateQueue)
                    self?.updateAttributesQueue.removeAll(where: { item in updateQueue.contains(where: { $0.span == item.span && $0.shouldApply == item.shouldApply })})
                }
            })
        } else {
            updateAttributesQueue.append(contentsOf: spans)
        }
    }
    
    //MARK: - Remove Style
    /**
     This will remove style from active sytyle if it contains it
     - Parameters:
     - style: which is of type TextSpanStyle
     
     This will remove typing attributes as well fot style.
     */
    private func removeStyle(_ style: TextSpanStyle) {
        guard activeStyles.contains(style) else { return }
        activeStyles.remove(style)
        updateTypingAttributes()
        
        
        guard !highlightedRange.isCollapsed else {
            return
        }
        
        let fromIndex = highlightedRange.lowerBound
        let toIndex = highlightedRange.upperBound
        
        let span = RichTextSpan(from: fromIndex, to: toIndex - 1, style: style)
        removeAttributes([span])
        
        let selectedParts = spans.filter({ $0.from < toIndex && $0.to >= fromIndex && $0.style == style })
        
        removeSpanForSelectedText(selectedParts, fromIndex: fromIndex, toIndex: toIndex)
    }
    
    /**
     This will update the typing attribute according to active style
     */
    private func updateTypingAttributes() {
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        activeStyles.forEach({
            attributes[$0.attributedStringKey] = $0.defaultAttributeValue(font: curretFont)
        })
        
        activeAttributes = attributes
    }
    
    /**
     This will remove the attributes from text for style
     - Parameters:
     - style:  which is of type of TextSpanStyle
     */
    private func removeAttributes(_ spans: [RichTextSpan]) {
        updateAttributes(spans: spans.map({ ($0, false) }))
    }
}

//MARK: - Helper Methods
extension RichEditorState {
    /**
     This will reset the editor. It will remove all the text form the editor.
     */
    public func reset() {
        spans.removeAll()
        rawText = ""
        editableText = NSMutableAttributedString(string: "")
    }
    
    /**
     This will allow you to set the editable text of editor
     */
    private func setEditable(editable: NSMutableAttributedString) {
        editable.append(NSMutableAttributedString(string: editable.string))
        self.editableText = editable
    }
    
    /**
     This will provide Set of TextSpanStyle applied on given index
     - Parameters:
     - index: index or location of text
     */
    private func getRichSpanStyleByTextIndex(_ index: Int) -> Set<TextSpanStyle> {
        let styles = Set(spans.filter { index >= $0.from && index <= $0.to }.map { $0.style })
        return styles
    }
    
    /**
     This will provide Array of TextSpanStyle applied on given range
     - Parameters:
     - rnage: range of text which is of type NSRange
     */
    private func getRichSpanStyleListByTextRange(_ range: NSRange) -> [TextSpanStyle] {
        return spans.filter({ range.closedRange.overlaps($0.closedRange) }).map { $0.style }
    }
    
    /**
     This will provide Array of RichTextSpan applied on given index
     - Parameters:
     - index: index or location of text
     */
    private func getRichSpansByTextIndex(_ index: Int) -> [RichTextSpan] {
        return spans.filter({ index >= $0.from && index <= $0.to })
    }
    
    /**
     This will provide Array of RichTextSpan applied on given range
     - Parameters:
     - rnage: range of text which is of type NSRange
     */
    private func getRichSpanListByTextRange(_ range: NSRange) -> [RichTextSpan] {
        return spans.filter({ range.closedRange.overlaps($0.closedRange) })
    }
}

//MARK: Span helper methods
extension RichEditorState {
    /**
     This will handle the newlly added character in editor
     - Parameters:
     - newValue: is of type NSMutableAttributedString
     
     This will generete break the span according to requirement to avoid duplication of the span.
     */
    private func handleAddingCharacters(_ newValue: NSMutableAttributedString) {
        let typedChars = newValue.string.utf16.count - rawText.utf16.count
        let startTypeIndex = highlightedRange.location - typedChars
        let startTypeChar = newValue.string.utf16.map({ $0 })[startTypeIndex]
        
        if startTypeChar == "\n".utf16.first && startTypeChar == "\n".utf16.last,
           activeStyles.contains(where: { $0.isHeaderStyle }) {
            activeStyles.removeAll()
        }
        
        var selectedStyles = activeStyles
        
        moveSpans(startTypeIndex: startTypeIndex, by: typedChars)
        
        let startParts = spans.filter { $0.closedRange.contains(startTypeIndex - 1) }
        let endParts = spans.filter { $0.closedRange.contains(startTypeIndex) }
        let commonParts = Set(startParts).intersection(Set(endParts))
        
        startParts.filter { !commonParts.contains($0) }.forEach { part in
            if selectedStyles.contains(part.style) {
                if let index = spans.firstIndex(of: part) {
                    spans[index] = part.copy(to: part.to + typedChars)
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
    
    /**
     This will handle the newlly added character in editor
     - Parameters:
     - startTypeIndex: is of type Int
     - by: is of type Int
     
     This will update the span according to requirement, like breake, removed, merge or extend.
     */
    private func processSpan(_ richTextSpan: RichTextSpan, typedChars: Int, startTypeIndex: Int, selectedStyles: inout Set<TextSpanStyle>, forward: Bool = false) {
        let newFromIndex = richTextSpan.from + typedChars
        let newToIndex = richTextSpan.to + typedChars
        
        if let index = spans.firstIndex(of: richTextSpan) {
            if selectedStyles.contains(richTextSpan.style) {
                spans[index] = richTextSpan.copy(to: newToIndex)
                selectedStyles.remove(richTextSpan.style)
            } else {
                if forward {
                    spans[index] = richTextSpan.copy(from: newFromIndex, to: newToIndex)
                } else {
                    spans[index] = richTextSpan.copy(to: startTypeIndex - 1)
                    spans.insert(richTextSpan.copy(from: startTypeIndex + typedChars, to: newToIndex), at: index + 1)
                    selectedStyles.remove(richTextSpan.style)
                }
            }
        }
    }
    
    /**
     This will handle the newlly added character in editor
     - Parameters:
     - startTypeIndex: is of type Int
     - step: is of type Int
     
     This will move the span according to it's position if it is after the typed character then it will move forward by number or typed character which is step.
     */
    private func moveSpans(startTypeIndex: Int, by step: Int) {
        let filteredSpans = spans.filter { $0.from > startTypeIndex }
        
        filteredSpans.forEach { part in
            if let index = spans.firstIndex(of: part) {
                spans[index] = RichTextSpan(from: part.from + step, to: part.to + step, style: part.style)
            }
        }
    }
    
    /**
     This will handle the removing character in editor and from relative span
     - Parameters:
     - newText: is of type NsMutableAttributedString
     
     This will generete, break  and remove the span according to requirement to avoid duplication and untracked span.
     */
    private func handleRemovingCharacters(_ newText: NSMutableAttributedString) {
        guard !newText.string.isEmpty else {
            spans.removeAll()
            activeStyles.removeAll()
            return
        }
        
        let removedCharsCount = rawText.count - newText.string.count
        let startRemoveIndex = highlightedRange.location
        let endRemoveIndex = highlightedRange.location + removedCharsCount - 1
        let removeRange = startRemoveIndex...endRemoveIndex
        let start = rawText.utf16.index(rawText.startIndex, offsetBy: startRemoveIndex)
        let end = rawText.utf16.index(rawText.startIndex, offsetBy: endRemoveIndex)
        
        if startRemoveIndex != endRemoveIndex, let newLineIndex = String(rawText[start...end]).map({ $0 }).lastIndex(of: "\n"), newLineIndex >= 0 {
            handleRemoveHeaderStyle(newText: newText.string, at: removeRange.nsRange, newLineIndex: newLineIndex)
        }
        
        let partsCopy = spans
        
        for part in partsCopy {
            if let index = spans.firstIndex(of: part) {
                if removeRange.upperBound < part.from {
                    spans[index] = RichTextSpan(from: part.from - removedCharsCount, to: part.to - removedCharsCount, style: part.style)
                } else if removeRange.lowerBound <= part.from && removeRange.upperBound >= part.to {
                    // Remove the element from the copy.
                    spans.removeAll(where: { $0 == part })
                } else if removeRange.lowerBound <= part.from {
                    spans[index] = RichTextSpan(from: max(0, removeRange.lowerBound), to: min(newText.string.count, part.to - removedCharsCount), style: part.style)
                } else if removeRange.upperBound <= part.to {
                    spans[index] = RichTextSpan(from: part.from, to: part.to - removedCharsCount, style: part.style)
                } else if removeRange.lowerBound < part.to {
                    spans[index] = RichTextSpan(from: part.from, to: removeRange.lowerBound, style: part.style)
                }
            }
        }
    }
}

//MARK: - Header style's relatated methods
extension RichEditorState {
    
    /**
     This will handle the adding header style in editor and to relative span
     - Parameters:
     - style: is of type TextSpanStyle
     */
    private func handleAddHeaderStyle(_ style: TextSpanStyle) {
        guard !rawText.isEmpty else {
            return
        }
        
        let fromIndex = highlightedRange.lowerBound
        let toIndex = highlightedRange.isCollapsed ? fromIndex : highlightedRange.upperBound
        let startIndex = max(0, rawText.utf16.prefix(fromIndex).map({ $0 }).lastIndex(of: "\n".utf16.last) ?? 0)
        let newLineAfterToIndex = rawText.utf16.suffix(from: rawText.utf16.index(rawText.utf16.startIndex, offsetBy: toIndex - 1)).map({ $0 }).firstIndex(of: "\n".utf16.last)
        var endIndex =  (toIndex - 1 ) + (newLineAfterToIndex ?? 0)
        
        if newLineAfterToIndex == nil {
            endIndex = (rawText.count - 1)
        }
        
        let range = startIndex...endIndex
        let selectedParts = spans.filter { ($0.closedRange.overlaps(range))
            && $0.style.isHeaderStyle }
        
        spans.removeAll(where: { selectedParts.contains($0) })
        let span = RichTextSpan(from: startIndex, to: endIndex, style: style)
        if !style.isDefault{
            spans.append(span)
        }
        
        applyStylesToSelectedText([span])
        
        /// Fonts are update for header which removes older style which is applyed to it so need to apply again.
        let spansToReapply = spans.filter({ $0.closedRange.overlaps(range) && !$0.style.isHeaderStyle })
        
        if !spansToReapply.isEmpty {
            applyStylesToSelectedText(spansToReapply)
        }
    }
    
    /**
     This will remove header style form selected range of text
     - Parameters:
     - newText: it's NSmutableAttributedString
     - range: is the NSRange
     - newLineIndex: is string index of new line where is it located
     */
    private func handleRemoveHeaderStyle(newText: String? = nil, at range: NSRange, newLineIndex: Int) {
        let text = newText ?? rawText
        let startIndex = max(0, text.map({ $0 }).index(before: newLineIndex))
        
        let endIndex = text.map({ $0 }).index(after: newLineIndex)
        
        let selectedParts = spans.filter({ ($0.from < endIndex && $0.to >= startIndex && $0.style.isHeaderStyle) })
        
        spans.removeAll(where: { selectedParts.contains($0) })
    }
    
    /**
     This will create span for selected text with provided style
     - Parameters:
     - style: is of type TextSpanStyle
     */
    private func createSpanForSelectedText(_ style: TextSpanStyle) {
        guard !highlightedRange.isCollapsed else {
            return
        }
        
        let fromIndex = highlightedRange.lowerBound
        let toIndex = highlightedRange.upperBound
        
        let selectedParts = spans.filter({ $0.from < toIndex && $0.to >= fromIndex })
        
        let startParts = spans.filter { $0.from == fromIndex }
        let endParts = spans.filter { $0.to == toIndex}
        
        if startParts.isEmpty && endParts.isEmpty && !selectedParts.isEmpty {
            spans.append(RichTextSpan(from: fromIndex, to: toIndex - 1, style: style))
        } else if startParts.contains(where: { $0.style == style }) {
            startParts.filter { $0.style == style }.forEach { part in
                if let index = spans.firstIndex(of: part) {
                    spans[index] = part.copy(to: toIndex - 1)
                }
            }
        } else if endParts.contains(where: { $0.style == style }) {
            endParts.filter { $0.style == style }.forEach { part in
                if let index = spans.firstIndex(of: part) {
                    spans[index] = part.copy(from: fromIndex)
                }
            }
        } else {
            spans.append(RichTextSpan(from: fromIndex, to: toIndex - 1, style: style))
        }
    }
    
    /**
     This will remove span for selected text
     - Parameters:
     - selectedParts: is of type [RichTextSpan]
     - fromIndex: is of type Int and it's lower bound of selection range
     - toIndex: is of type Int and it's upper bound of selection range
     */
    private func removeSpanForSelectedText(_ selectedParts: [RichTextSpan], fromIndex: Int, toIndex: Int) {
        selectedParts.forEach { part in
            if let index = spans.firstIndex(of: part) {
                if part.from < fromIndex && part.to >= toIndex {
                    spans[index] = part.copy(to: fromIndex - 1)
                    spans.insert(part.copy(from: toIndex), at: index + 1)
                } else if part.from < fromIndex {
                    spans[index] = part.copy(to: fromIndex - 1)
                } else if part.to > toIndex {
                    spans[index] = part.copy(from: toIndex)
                } else {
                    spans.remove(at: index)
                }
            }
        }
    }
}
