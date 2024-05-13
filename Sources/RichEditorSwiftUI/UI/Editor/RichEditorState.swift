//
//  RichEditorState.swift
//
//
//  Created by Divyesh Vekariya on 11/12/23.
//

import Foundation
import SwiftUI

public class RichEditorState: ObservableObject {
    private var adapter: EditorAdapter = DefaultAdapter()

    @Published internal var editableText: NSMutableAttributedString
    @Published internal var activeStyles: Set<TextSpanStyle> = []
    @Published internal var activeAttributes: [NSAttributedString.Key: Any]? = [:]
    internal var currentFont: FontRepresentable = .systemFont(ofSize: .standardRichTextFontSize)

    @Published internal var attributesToApply: ((spans: [(span:RichTextSpanInternal, shouldApply: Bool)], onCompletion: () -> Void))? = nil
    @Published internal var insertTextAt: (list: [(text: String, atIndex: [Int], shouldInsert: Bool)], onCompletion: (() -> Void))? = nil

    private var activeSpans: RichTextSpans = []

    //    private var internalSpans: [RichTextSpan] = []

    private var internalSpans: [RichTextSpanInternal] = []

    private var highlightedRange: NSRange
    private var rawText: String

    private var insertTextQueue: [(text: String, atIndex: [Int], shouldInsert: Bool)] = []
    private var updateAttributesQueue: [(span:RichTextSpanInternal, shouldApply: Bool)] = []

    /**
     This will provide encoded text which is of type RichText
     */
    public var richText: RichText {
        return getRichText()
    }

    public var attributedText: NSAttributedString {
        return editableText.attributedString
    }

    private var spans: RichTextSpans {
        return internalSpans.map({ .init(insert: getStringWith(from: $0.from, to: $0.to), attributes: $0.attributes) })
    }

    //MARK: - Initializers
    /**
     Init with richText which is of type RichText
     */
    public init(richText: RichText) {
        let input = richText.spans.map({ $0.insert }).joined()
        let adapter = DefaultAdapter()

        self.adapter = adapter
        self.editableText = NSMutableAttributedString(string: input)
        var tempSpans: [RichTextSpanInternal] = []
        var text = ""
        richText.spans.forEach({
            let span = RichTextSpanInternal(from: text.count,
                                            to: (text.count + $0.insert.count - 1),
                                            attributes: $0.attributes)
            tempSpans.append(span)
            text += $0.insert
        })
        self.editableText = NSMutableAttributedString(string: text)

        self.internalSpans = tempSpans

        highlightedRange = NSRange(location: 0, length: 0)
        activeStyles = []

        rawText = input
        setUpSpans()
    }

    /**
     Init with input which is of type String
     */
    public init(input: String) {
        let adapter = DefaultAdapter()

        self.adapter = adapter
        self.editableText = NSMutableAttributedString(string: input)

        self.internalSpans = [.init(from: 0, to: input.count > 0 ? input.count - 1 : 0, attributes: RichAttributes())]

        highlightedRange = NSRange(location: 0, length: 0)
        activeStyles = []

        rawText = input
        setUpSpans()
    }
}

//MARK: - Public Methods
extension RichEditorState {
    func getStringWith(from: Int, to: Int) -> String {
        guard (to - from) >= 0 else { return "" }
        return editableText.string.substring(from: .init(location: from, length: (to - from)))
    }

    /**
     This will provide RichText which is encoded from input and editor text
     */
    private func getRichText() -> RichText {
        return editableText.string.isEmpty ? RichText() : RichText(spans: spans)
    }

    /**
     This will provide String value from editor
     */
    public func output() -> String {
        return (try? adapter.encode(type: richText)) ?? ""
    }

    /**
     This will export editor text as JSON string
     */
    public func export() -> String? {
        return (try? adapter.encode(type: richText))
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
     This will setup editor according to spans provided in init
     */
    private func setUpSpans() {
        applyStylesToSelectedText(internalSpans)
    }
}

//MARK: - TextView Helper Methods
extension RichEditorState {
    /**
     Handle UITextView's delegate methods calles
     - Parameters:
     - event: is of type TextViewEvents
     This will switch on event and call respective method
     */
    internal func onTextViewEvent(_ event: TextViewEvents) {
        switch event {
        case .didChangeSelection(let textView):
            highlightedRange = textView.selectedRange
            print("==== selection is \(highlightedRange)")
            print("===== spans are \(spans.map({ ($0.insert, $0.attributes?.styles().map({ $0.key })) }))")
            print("===== internal spans \(internalSpans.map({ ("\($0.from)...\($0.to)" ) }))")
            guard rawText.count == textView.attributedText.string.count && highlightedRange.isCollapsed else { return }
            onSelectionDidChanged()
        case .didBeginEditing(let textView):
            highlightedRange = textView.selectedRange
        case .didChange:
            onTextFieldValueChange(newText: editableText, selection: highlightedRange)
        case .didEndEditing:
            highlightedRange = .init(location: 0, length: 0)
        }
    }

    /**
     This will decide whether Character is added or removed and perform accordingly
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
    internal func onSelectionDidChanged() {
        updateCurrentSpanStyle()
    }

    /**
     Set the activeStyles
     - Parameters:
     - style: is of type TextSpanStyle
     This will set the activeStyle according to style  passed
     */
    private func setStyle(_ style: TextSpanStyle) {
        activeStyles.removeAll()
        activeAttributes = [:]
        activeStyles.insert(style)

        if style.isHeaderStyle || style.isDefault {
            handleAddOrRemoveHeaderStyle(in: highlightedRange, style: style, byAdding: !style.isDefault)
        } else if !highlightedRange.isCollapsed {
            processSpansFor(new: style, in: highlightedRange)
        }

        updateCurrentSpanStyle()
    }

    /**
     Update the activeStyles and activeAttributes
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
            attributes[$0.attributedStringKey] = $0.defaultAttributeValue(font: currentFont)
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
}

//MARK: - Add styles
extension RichEditorState {
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
            handleAddOrRemoveHeaderStyle(in: highlightedRange, style: style)
//        } else if style.isList {
//            handleAddOrRemoveListStyle(in: highlightedRange, style: style)
        } else if !highlightedRange.isCollapsed {
            processSpansFor(new: style, in: highlightedRange)
        }
    }

    /**
     This will add style to the range of text
     - Parameters:
     - style: which is of type TextSpanStyle
     - range: is the range of the text on which you want to apply the style
     */
    private func applyStylesToSelectedText(_ spans: [RichTextSpanInternal]) {
        updateAttributes(spans: spans.map({ ($0, true) }))
    }

    /**
     This will update editor text according to span provided in  argument
     - Parameters:
     - spans: Which is of type Tuple of  RichTextSpan and Bool

     Where Bool is indicate whether this style is need to add or remove.
     */
    private func updateAttributes(spans: [(RichTextSpanInternal, shouldApply: Bool)]) {
        if attributesToApply == nil {
            attributesToApply = (spans: spans, onCompletion: { [weak self] in
                Task { @MainActor [weak self] in
                    self?.attributesToApply = nil
                }
                if let updateQueue = self?.updateAttributesQueue, !updateQueue.isEmpty {
                    self?.updateAttributes(spans: updateQueue)
                    self?.updateAttributesQueue.removeAll(where: { item in
                        updateQueue.contains(where: { $0.span == item.span
                            && $0.shouldApply == item.shouldApply
                        })
                    })
                }
            })
        } else {
            updateAttributesQueue.append(contentsOf: spans)
        }
    }

    //MARK: - Remove Style
    /**
     This will remove style from active style if it contains it
     - Parameters:
     - style: which is of type TextSpanStyle

     This will remove typing attributes as well for style.
     */
    private func removeStyle(_ style: TextSpanStyle) {
        guard activeStyles.contains(style) || style.isDefault else { return }
        activeStyles.remove(style)
        updateTypingAttributes()

        if style.isHeaderStyle || style.isDefault {
            handleAddOrRemoveHeaderStyle(in: highlightedRange, style: style, byAdding: false)
//        } else if style.isList {
//            handleAddOrRemoveListStyle(in: highlightedRange, style: style, byAdding: false)
        } else if !highlightedRange.isCollapsed {
            processSpansFor(new: style, in: highlightedRange, addStyle: false)
        }
    }

    /**
     This will update the typing attribute according to active style
     */
    private func updateTypingAttributes() {
        var attributes: [NSAttributedString.Key: Any] = [:]

        activeStyles.forEach({
            attributes[$0.attributedStringKey] = $0.defaultAttributeValue(font: currentFont)
        })

        activeAttributes = attributes
    }

    /**
     This will remove the attributes from text for style
     - Parameters:
     - style:  which is of type of TextSpanStyle
     */
    private func removeAttributes(_ spans: [RichTextSpanInternal]) {
        updateAttributes(spans: spans.map({ ($0, false) }))
    }
}

//MARK: - Add character
extension RichEditorState {

    /**
     This will handle the newly added character in editor
     - Parameters:
     - newValue: is of type NSMutableAttributedString

     This will generate break the span according to requirement to avoid duplication of the span.
     */
    private func handleAddingCharacters(_ newValue: NSMutableAttributedString) {
        guard !highlightedRange.isCollapsed else { return }
        let typedChars = newValue.string.utf16Length - rawText.utf16Length
        let startTypeIndex = highlightedRange.location - typedChars
        let startTypeChar = newValue.string.utf16.map({ $0 })[startTypeIndex]

        if startTypeChar == "\n".utf16.first && startTypeChar == "\n".utf16.last,
           activeStyles.contains(where: { $0.isHeaderStyle }) {
            activeStyles.removeAll()
        }
//        if startTypeChar == "\n".utf16.first && startTypeChar == "\n".utf16.last {
//            if activeStyles.contains(where: { $0.isHeaderStyle }) {
//                activeStyles.removeAll()
//            }
//        }
//
//        defer {
//            if activeStyles.contains(.bullet) && startTypeChar == "\n".utf16.first && startTypeChar == "\n".utf16.last {
//                insertTextAt = (text: "\u{2022}", atIndex: startTypeIndex + typedChars, onComplete: {})
//            }
//        }

        var selectedStyles = activeStyles

        moveSpansForward(startTypeIndex: startTypeIndex, by: typedChars)

        let startParts = internalSpans.filter { $0.closedRange.contains(startTypeIndex - 1) }
        let endParts = internalSpans.filter { $0.closedRange.contains(startTypeIndex) }
        let commonParts = Set(startParts).intersection(Set(endParts))

        var addedInFirstPart: Bool = false

        startParts.filter { !commonParts.contains($0) }.forEach { part in
            if selectedStyles == part.attributes?.stylesSet() {
                if let index = internalSpans.firstIndex(of: part) {
                    internalSpans[index] = part.copy(to: part.to + typedChars)
                    selectedStyles.removeAll()
                    addedInFirstPart = true
                }
            }
        }

        if !addedInFirstPart {
            endParts.filter { !commonParts.contains($0) }.forEach { part in
                processSpan(part, typedChars: typedChars, startTypeIndex: startTypeIndex, selectedStyles: &selectedStyles, forward: true)
            }
        }

        commonParts.forEach { part in
            processSpan(part, typedChars: typedChars, startTypeIndex: startTypeIndex, selectedStyles: &selectedStyles)
        }

        internalSpans = mergeSameStyledSpans(internalSpans)

        guard !internalSpans.contains(where: { $0.closedRange.contains(startTypeIndex) }) else { return }
        let toIndex = typedChars > 1 ? (startTypeIndex + typedChars - 1) : startTypeIndex
        let span = RichTextSpanInternal(from: startTypeIndex, to: toIndex, attributes: getRichAttributesFor(styles: Array(selectedStyles)))
        internalSpans.append(span)
    }

    /**
     This will handle the newly added character in editor
     - Parameters:
     - startTypeIndex: is of type Int
     - by: is of type Int

     This will update the span according to requirement, like break, remove, merge or extend.
     */
    private func processSpan(_ richTextSpan: RichTextSpanInternal, typedChars: Int, startTypeIndex: Int, selectedStyles: inout Set<TextSpanStyle>, forward: Bool = false) {
        let newFromIndex = richTextSpan.from + typedChars
        let newToIndex = richTextSpan.to + typedChars

        if let index = internalSpans.firstIndex(of: richTextSpan) {
            if selectedStyles == richTextSpan.attributes?.stylesSet() {
                internalSpans[index] = richTextSpan.copy(to: newToIndex)
                selectedStyles.removeAll()
            } else {
                if forward {
                    internalSpans[index] = richTextSpan.copy(from: newFromIndex, to: newToIndex)
                } else {
                    divideSpanAndAddTextWithCurrentStyle(span: richTextSpan, typedChars: typedChars, startTypeIndex: startTypeIndex, with: &selectedStyles)
                    selectedStyles.removeAll()
                }
            }
        }
    }

    func divideSpanAndAddTextWithCurrentStyle(span: RichTextSpanInternal, typedChars: Int, startTypeIndex: Int, with styles: inout Set<RichTextStyle>) {
        guard let index = internalSpans.firstIndex(of: span) else { return }
        let extendedSpan = span.copy(to: span.to + typedChars)

        let startIndex = startTypeIndex
        let endIndex = startTypeIndex + typedChars - 1

        var spansToAdd: [RichTextSpanInternal] = []
        spansToAdd.append(RichTextSpanInternal(from: startIndex, to: endIndex, attributes:  getRichAttributesFor(styles: Array(styles))))

        if startTypeIndex == extendedSpan.from {
            spansToAdd.append(extendedSpan.copy(from: endIndex))
        } else if endIndex == extendedSpan.to {
            spansToAdd.append(extendedSpan.copy(to: startIndex - 1))
        } else {
            spansToAdd.append(extendedSpan.copy(to: startIndex - 1))
            spansToAdd.append(extendedSpan.copy(from: endIndex + 1))
        }
        internalSpans.removeAll(where: { $0 == span})
        internalSpans.insert(contentsOf: spansToAdd.sorted(by: { $0.from < $1.from }), at: index)
    }

    /**
     This will handle the newly added character in editor
     - Parameters:
     - startTypeIndex: is of type Int
     - step: is of type Int

     This will move the span according to it's position if it is after the typed character then it will move forward by number or typed character which is step.
     */
    private func moveSpansForward(startTypeIndex: Int, by step: Int) {
        let filteredSpans = internalSpans.filter { $0.from >= startTypeIndex }

        filteredSpans.forEach { part in
            if let index = internalSpans.firstIndex(of: part) {
                internalSpans[index] = part.copy(from: part.from + step, to: part.to + step)
            }
        }
    }
}

//MARK: - Remove Character
extension RichEditorState {
    /**
     This will handle the removing character in editor and from relative span
     - Parameters:
     - newText: is of type NsMutableAttributedString

     This will generate, break  and remove the span according to requirement to avoid duplication and untracked span.
     */
    private func handleRemovingCharacters(_ newText: NSMutableAttributedString) {
        guard !newText.string.isEmpty else {
            internalSpans.removeAll()
            activeStyles.removeAll()
            return
        }

        let removedCharsCount = rawText.utf16Length - newText.string.utf16Length
        let startRemoveIndex = highlightedRange.location
        let endRemoveIndex = highlightedRange.location + removedCharsCount - 1
        let removeRange = startRemoveIndex...endRemoveIndex
        let start = rawText.utf16.index(rawText.startIndex, offsetBy: startRemoveIndex)
        let end = rawText.utf16.index(rawText.startIndex, offsetBy: endRemoveIndex)

//        if !activeStyles.contains(.bullet) {
            //            handleRemoveBulletStyle()
//        } else 
        if startRemoveIndex != endRemoveIndex, let newLineIndex = String(rawText[start...end]).map({ $0 }).lastIndex(of: "\n"), newLineIndex >= 0 {
            handleRemoveHeaderStyle(newText: newText.string, at: removeRange.nsRange, newLineIndex: newLineIndex)
        }

        let partsCopy = internalSpans

        let lowerBound = removeRange.lowerBound //- (highlightedRange.length < removedCharsCount ? 1 : 0)

        for part in partsCopy {
            if let index = internalSpans.firstIndex(of: part) {
                if removeRange.upperBound < part.from {
                    internalSpans[index] = part.copy(from: part.from - (removedCharsCount), to: part.to - (removedCharsCount))
                } else if lowerBound <= part.from && removeRange.upperBound >= part.to {
                    internalSpans.removeAll(where: { $0 == part })
                } else if lowerBound <= part.from {
                    internalSpans[index] = part.copy(from: max(0, lowerBound), to: min(newText.string.count, part.to - removedCharsCount))
                } else if removeRange.upperBound <= part.to {
                    internalSpans[index] = part.copy(to: part.to - removedCharsCount)
                } else if lowerBound < part.to {
                    internalSpans[index] = part.copy(to: lowerBound)
                }
            }
        }
    }

    /**
     This will handle the newly added character in editor
     - Parameters:
     - startTypeIndex: is of type Int
     - step: is of type Int

     This will move the span according to it's position if it is after the typed character then it will move forward by number or typed character which is step.
     */
    private func moveSpansBackward(endTypeIndex: Int, by step: Int) {
        let filteredSpans = internalSpans.filter { $0.to > endTypeIndex}

        filteredSpans.forEach { part in
            if let index = internalSpans.firstIndex(of: part) {
                internalSpans[index] = part.copy(from: part.from - step, to: part.to - step)
            }
        }
    }
}

//MARK: - Header style's related methods
extension RichEditorState {
    //MARK: - Remove Header style
    /**
     This will handle the adding header style in editor and to relative span
     - Parameters:
     - style: is of type TextSpanStyle
     */
    private func handleAddOrRemoveHeaderStyle(in range: NSRange, style: TextSpanStyle, byAdding: Bool = true) {
        guard !rawText.isEmpty else { return }

        let range = getHeaderRangeFor(range, in: rawText)
        processSpansFor(new: style, in: range, addStyle: byAdding)
    }

    private func getHeaderRangeFor(_ range: NSRange, in text: String) -> NSRange {
        guard !text.isEmpty else { return range }

        let fromIndex = range.lowerBound
        let toIndex = range.isCollapsed ? fromIndex : range.upperBound

        let newLineStartIndex = text.utf16.prefix(fromIndex).map({ $0 }).lastIndex(of: "\n".utf16.last) ?? 0
        let newLineEndIndex = text.utf16.suffix(from: text.utf16.index(text.utf16.startIndex, offsetBy: toIndex - 1)).map({ $0 }).firstIndex(of: "\n".utf16.last)

        let startIndex = max(0, newLineStartIndex)
        var endIndex = (toIndex - 1) + (newLineEndIndex ?? 0)

        if newLineEndIndex == nil {
            endIndex = (text.utf16Length)
        }

        let range = startIndex...endIndex
        return range.nsRange
    }

    /**
     This will remove header style form selected range of text
     - Parameters:
     - newText: it's NSMutableAttributedString
     - range: is the NSRange
     - newLineIndex: is string index of new line where is it located
     */
    private func handleRemoveHeaderStyle(newText: String? = nil, at range: NSRange, newLineIndex: Int) {
        let text = newText ?? rawText
        let startIndex = max(0, text.map({ $0 }).index(before: newLineIndex))

        let endIndex = text.map({ $0 }).index(after: newLineIndex)

        let selectedParts = internalSpans.filter({ ($0.from < endIndex && $0.to >= startIndex && $0.attributes?.header != nil) })

        internalSpans.removeAll(where: { selectedParts.contains($0) })
    }

    //MARK: - Add Header style
    /**
     This will create span for selected text with provided style
     - Parameters:
     - styles: is of type [TextSpanStyle]
     - range: is of type NSRange
     */
    private func processSpansFor(new style: RichTextStyle, in range: NSRange, addStyle: Bool = true) {
        guard !range.isCollapsed else {
            return
        }

        var processedSpans: [RichTextSpanInternal] = []

        let fromIndex = range.lowerBound
        let toIndex = range.upperBound

        let completeOverlap = getCompleteOverlappingSpans(for: range)
        var partialOverlap = getPartialOverlappingSpans(for: range)
        var sameSpans = getSameSpans(for: range)

        partialOverlap.removeAll(where: { completeOverlap.contains($0) })
        sameSpans.removeAll(where: { completeOverlap.contains($0) })

        let partialOverlapSpan = processPartialOverlappingSpans(partialOverlap, range: range, style: style, addStyle: addStyle)
        let completeOverlapSpan = processCompleteOverlappingSpans(completeOverlap, range: range, style: style, addStyle: addStyle)
        let sameSpan = processSameSpans(sameSpans, range: range, style: style, addStyle: addStyle)

        processedSpans.append(contentsOf: partialOverlapSpan)
        processedSpans.append(contentsOf: completeOverlapSpan)
        processedSpans.append(contentsOf: sameSpan)

        processedSpans = mergeSameStyledSpans(processedSpans)

        internalSpans.removeAll(where: { $0.closedRange.overlaps(range.closedRange) })
        internalSpans.append(contentsOf:  processedSpans)
        internalSpans = mergeSameStyledSpans(internalSpans)
        internalSpans.sort(by: { $0.from < $1.from })


        var spansToUpdate = getOverlappingSpans(for: range)
        if addStyle || style.isDefault {
            if style.isDefault {
                /// This will help to apply header style without loosing other style
                let span = RichTextSpanInternal(from: fromIndex, to: toIndex, attributes: style == .default ? .init(header: .default) : getRichAttributesFor(style: style))
                spansToUpdate.append(span)
            } else if !style.isHeaderStyle {
                //When selected range's is surrounded with same styled text it helps to update selected text in editor
                let span = RichTextSpanInternal(from: fromIndex, to: toIndex, attributes: getRichAttributesFor(style: style))
                spansToUpdate.append(span)
            }
            applyStylesToSelectedText(spansToUpdate)

        } else {
            let span = RichTextSpanInternal(from: fromIndex, to: (toIndex - 1), attributes: getRichAttributesFor(style: style))
            removeAttributes([span])
            //To apply style as remove span is removing other styles as well.
            applyStylesToSelectedText(spansToUpdate)
        }
    }

    private func processCompleteOverlappingSpans(_ spans: [RichTextSpanInternal], range: NSRange, style: RichTextStyle, addStyle: Bool = true) -> [RichTextSpanInternal] {
        var processedSpans: [RichTextSpanInternal] = []

        for span in spans {
            if span.closedRange.isInRange(range.closedRange) {
                processedSpans.append(span.copy(attributes: span.attributes?.copy(with: style, byAdding: addStyle)))
            } else {
                if span.from < range.lowerBound {
                    let leftPart = span.copy(to: range.lowerBound - 1)
                    processedSpans.append(leftPart)
                }

                if span.from <= (range.lowerBound) && span.to >= (range.upperBound - 1) {
                    let centerPart = span.copy(from: range.lowerBound, to: range.upperBound - 1, attributes: span.attributes?.copy(with: style, byAdding: addStyle))
                    processedSpans.append(centerPart)
                }

                if span.to > (range.upperBound - 1) {
                    let rightPart = span.copy(from: range.upperBound)
                    processedSpans.append(rightPart)
                }
            }
        }

        processedSpans = mergeSameStyledSpans(processedSpans)

        return processedSpans
    }

    private func processPartialOverlappingSpans(_ spans: [RichTextSpanInternal], range: NSRange, style: RichTextStyle, addStyle: Bool = true) -> [RichTextSpanInternal] {
        var processedSpans: [RichTextSpanInternal] = []

        for span in spans {
            if span.from < range.location {
                let leftPart = span.copy(to: range.lowerBound - 1)
                let rightPart = span.copy(from: range.lowerBound, attributes: span.attributes?.copy(with: style, byAdding: addStyle))
                processedSpans.append(leftPart)
                processedSpans.append(rightPart)
            } else {
                let leftPart = span.copy(to: min(span.to, range.upperBound), attributes: span.attributes?.copy(with: style, byAdding: addStyle))
                let rightPart = span.copy(from: range.location)
                processedSpans.append(leftPart)
                processedSpans.append(rightPart)
            }
        }

        processedSpans = mergeSameStyledSpans(processedSpans)
        return processedSpans
    }

    private func processSameSpans(_ spans: [RichTextSpanInternal], range: NSRange, style: RichTextStyle, addStyle: Bool = true) -> [RichTextSpanInternal] {
        var processedSpans: [RichTextSpanInternal] = []

        processedSpans = spans.map({ $0.copy(attributes: $0.attributes?.copy(with: style, byAdding: addStyle)) })

        processedSpans = mergeSameStyledSpans(processedSpans)
        return processedSpans
    }

    // merge adjacent spans with same style
    private func mergeSameStyledSpans(_ spans: [RichTextSpanInternal]) -> [RichTextSpanInternal] {
        var mergedSpans: [RichTextSpanInternal] = []
        var previousSpan: RichTextSpanInternal?

        for span in spans.sorted(by: { $0.from < $1.from }) {
            if let current = previousSpan {
                if span.attributes?.stylesSet() == current.attributes?.stylesSet() {
                    // Merge overlapping spans
                    previousSpan = current.copy(to: max(current.to, span.to))
                } else {
                    // Add merged span and start a new span
                    mergedSpans.append(current)
                    previousSpan = span
                }
            } else {
                previousSpan = span
            }
        }

        // Append the last current span
        if let lastSpan = previousSpan {
            mergedSpans.append(lastSpan)
        }

        return mergedSpans.sorted(by: { $0.from < $1.from })
    }
}

//MARK: - Add Bullet list
extension RichEditorState {
    /**
     This will add bullet style to selected text
     */
    func addBulletStyle(style: TextSpanStyle, selectedRange: NSRange) {
    }

    /**
     This will handle adding or removing bullet style from selected text
     */
    private func handleAddOrRemoveListStyle(in range: NSRange, style: TextSpanStyle, byAdding: Bool = true) {
        guard !range.isCollapsed else { return }
        var listIndicatorTextCount = 0

        if let listType = style.listType {
//            listIndicatorTextCount = listType.getListIndicator().utf16Length
        }

        let listItems: [NSRange] = getListItemsRangesFor(range, in: rawText).enumerated().map({ NSRange(location: $0.element.location + (byAdding ? ($0.offset * listIndicatorTextCount) : 0), length: $0.element.length) })

        print("===== creteList \(listItems.map({ "\($0.lowerBound)...\($0.upperBound)" }))")

        let ranges = listItems.enumerated().map({ NSRange(location: $0.element.location, length: ($0.element.length + listIndicatorTextCount)) })

        print("===== Ranges \(ranges.map({ "\($0.lowerBound)...\($0.upperBound)" }))")

        ranges.forEach({
            processSpansFor(new: style, in: $0, addStyle: byAdding)
        })

        if let listType = style.listType {
            if byAdding {
                createListFor(listItems, with: listType)
            } else {
                removeListFor(listItems, with: listType)
            }
        }

        print("====== processedSpans \(internalSpans.map({ "\($0.from)...\($0.to)" }))")

        print("==== spans AF \(spans.map({ "\($0.insert), " }))")
    }

//    ===== Ranges ["5...12", "13...20", "21...28", "29...36", "37...42"]

    func createListFor(_ ranges: [NSRange], with style: ListType) {
//        insertOrRemoveText(list: [(text: style.getListIndicator(), atIndex: ranges.map({ $0.location }), shouldInsert: true)])
    }

    func getListItemsRangesFor(_ range: NSRange, in text: String) -> [NSRange] {
        let newLineRange = getHeaderRangeFor(range, in: text)
        var listItemsRanges: [NSRange] = []

        // Define your regex pattern to match list items, assuming a simple pattern for demonstration
        let regexPattern = "\n" // This is a basic pattern matching bullet points followed by text

        // Create a regular expression object
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: []) else {
            return []
        }

        // Iterate through matches in the specified range
        regex.enumerateMatches(in: text, options: [], range: newLineRange) { match, _, _ in
            if let matchRange = match?.range {
                listItemsRanges.append(matchRange)
            }
        }

        var lastRange: NSRange? = nil
        var listRanges: [NSRange] = []

        listItemsRanges.forEach({ item in
            if let previousRange = lastRange {
                listRanges.append(.init(location: previousRange.location + 1, length: (item.location - previousRange.location)))
                lastRange = item
            } else {
                lastRange = item
            }
        })

        if let lastRange = lastRange {
            listRanges.append(.init(location: lastRange.location + 1, length: (range.upperBound - lastRange.location)))
        }

        print("===== listItems \(listRanges.map({ "\($0.location)" }))")

        return listRanges
    }

    /**
        This will inert or remove text at specified index
     */
    private func insertOrRemoveText(list: [(text: String, atIndex: [Int], shouldInsert: Bool)]) {
        guard !list.isEmpty else { return }

        if insertTextAt == nil {
            insertTextAt = (list: list, onCompletion: { [weak self] in
                self?.insertTextAt = nil
                if let insertOrRemoveQueue = self?.insertTextQueue, !insertOrRemoveQueue.isEmpty {
                    self?.insertOrRemoveText(list: insertOrRemoveQueue)
                    self?.insertTextQueue.removeAll(where: { item in
                        insertOrRemoveQueue.contains(where: { $0.text == item.text
                            && $0.atIndex == item.atIndex && $0.shouldInsert == item.shouldInsert
                        })
                    })
                }
            })
        } else {
            insertTextQueue.append(contentsOf: list)
        }
    }
}


//MARK: - Remove Bullet list
extension RichEditorState {

    /**
     This will remove bullet style from selected text
     */
    func removeBulletStyle() {
    }

    func removeListFor(_ ranges: [NSRange], with style: ListType) {
    }
}

//MARK: - RichTextSpanInternal Helper
extension RichEditorState {
    /**
     This will provide overlapping span for range
     - Parameters:
     - selectedRange:  is of type NSRange
     */

    private func getOverlappingSpans(for selectedRange: NSRange) -> [RichTextSpanInternal] {
        return internalSpans.filter { $0.closedRange.overlaps(selectedRange.closedRange) }
    }

    /**
     This will provide partial overlapping span for range
     - Parameters:
     - selectedRange: selectedRange is of type NSRange
     */

    func getPartialOverlappingSpans(for selectedRange: NSRange) -> [RichTextSpanInternal] {
        return getOverlappingSpans(for: selectedRange).filter({ $0.closedRange.isPartialOverlap(selectedRange.closedRange) })
    }

    /**
     This will provide complete overlapping span for range
     - Parameters:
     - selectedRange: selectedRange is of type NSRange
     */
    func getCompleteOverlappingSpans(for selectedRange: NSRange) -> [RichTextSpanInternal] {
        return getOverlappingSpans(for: selectedRange).filter({ $0.closedRange.isInRange(selectedRange.closedRange) || selectedRange.closedRange.isInRange($0.closedRange)})
    }

    /**
     This will provide same span for range
     - Parameters:
     - selectedRange: selectedRange is of type NSRange
     */

    func getSameSpans(for selectedRange: NSRange) -> [RichTextSpanInternal] {
        return getOverlappingSpans(for: selectedRange).filter({ $0.closedRange.isSameAs(selectedRange.closedRange) })
    }
}


//MARK: - Helper Methods
extension RichEditorState {
    /**
     This will reset the editor. It will remove all the text form the editor.
     */
    public func reset() {
        internalSpans.removeAll()
        rawText = ""
        editableText = NSMutableAttributedString(string: "")
    }

    /**
     This will provide Set of TextSpanStyle applied on given index
     - Parameters:
     - index: index or location of text
     */
    private func getRichSpanStyleByTextIndex(_ index: Int) -> Set<TextSpanStyle> {
        let styles = Set(internalSpans.filter { index >= $0.from && index <= $0.to }.map { $0.attributes?.styles() ?? []}.flatMap({ $0 }))
        return styles
    }

    /**
     This will provide Array of TextSpanStyle applied on given range
     - Parameters:
     - range: range of text which is of type NSRange
     */
    private func getRichSpanStyleListByTextRange(_ range: NSRange) -> [TextSpanStyle] {
        return internalSpans.filter({ range.closedRange.overlaps($0.closedRange) }).map { $0.attributes?.styles() ?? [] }.flatMap({ $0 })
    }
}
