//
//  RichEditorState+Spans.swift
//
//
//  Created by Divyesh Vekariya on 11/12/23.
//

import Foundation
import SwiftUI

//MARK: - Public Methods
extension RichEditorState {
    func getStringWith(from: Int, to: Int) -> String {
        guard (to - from) >= 0 else { return "" }
        return attributedString.string.substring(from: .init(location: from, length: (to - from)))
    }

    /**
     This will provide RichText which is encoded from input and editor text
     */
    internal func getRichText() -> RichText {
        return attributedString.string.isEmpty ? RichText() : RichText(spans: spans)
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
     - style: is of type RichTextSpanStyle
     */
    public func toggleStyle(style: RichTextSpanStyle) {
        if activeStyles.contains(style) {
            setInternalStyles(style: style, add: false)
            removeStyle(style)
        } else {
            setInternalStyles(style: style)
            addStyle(style)
        }
    }

    /**
     This will update the style
     - Parameters:
     - style: is of type RichTextSpanStyle
     */
    public func updateStyle(style: RichTextSpanStyle) {
        setInternalStyles(style: style)
        setStyle(style)
    }

    /**
     This will setup editor according to spans provided in init
     */
    internal func setUpSpans() {
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
        case .didChangeSelection(let range, let text):
            selectedRange = range
            guard rawText.count == text.string.count && selectedRange.isCollapsed else {
                return
            }
            onSelectionDidChanged()
        case .didBeginEditing(let range, _):
            selectedRange = range
        case .didChange:
            onTextFieldValueChange(newText: attributedString, selection: selectedRange)
        case .didEndEditing:
            selectedRange = .init(location: 0, length: 0)
        }
    }

    /**
     This will decide whether Character is added or removed and perform accordingly
     - Parameters:
     - newText: is updated NSMutableAttributedString
     - selection: is the range of the selected text
     */
    private func onTextFieldValueChange(newText: NSAttributedString, selection: NSRange) {
        self.selectedRange = selection

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
     - style: is of type RichTextSpanStyle
     This will set the activeStyle according to style  passed
     */
    private func setStyle(_ style: RichTextSpanStyle) {
        activeStyles.removeAll()
        activeAttributes = [:]
        activeStyles.insert(style)

        if style.isHeaderStyle || style.isDefault || style.isList || style.isAlignmentStyle {
            handleAddOrRemoveHeaderOrListStyle(in: selectedRange, style: style, byAdding: !style.isDefault)
        } else if !selectedRange.isCollapsed {
            let addStyle = checkIfStyleIsActiveWithSameAttributes(style)
            processSpansFor(new: style, in: selectedRange, addStyle: addStyle)
        }

        updateCurrentSpanStyle()
    }

    func checkIfStyleIsActiveWithSameAttributes(_ style: RichTextSpanStyle) -> Bool {
        var addStyle: Bool = true
        switch style {
        case .size(let size):
            if let size {
                addStyle = CGFloat(size) == CGFloat.standardRichTextFontSize
            }
        case .font(let fontName):
            if let fontName {
                addStyle = fontName == self.fontName
            }
        case .color(let color):
            if let color, color.toHex() != Color.primary.toHex() {
                if let internalColor = self.color(for: .foreground) {
                    addStyle = Color(internalColor) != color
                } else {
                    addStyle = true
                }
            } else {
                addStyle = false
            }
        case .background(let bgColor):
            if let color = bgColor, color.toHex() != Color.clear.toHex() {
                if let internalColor = self.color(for: .background) {
                    addStyle = Color(internalColor) != color
                } else {
                    addStyle = true
                }
            } else {
                addStyle = false
            }
        case .align(let alignment):
            if let alignment {
                addStyle = alignment != self.textAlignment || alignment != .left
            }
        default:
            return addStyle
        }

        return addStyle
    }

    /**
     Update the activeStyles and activeAttributes
     */
    internal func updateCurrentSpanStyle() {
        guard !attributedString.string.isEmpty else { return }
        var newStyles: Set<RichTextSpanStyle> = []

        if selectedRange.isCollapsed {
            newStyles = getRichSpanStyleByTextIndex(selectedRange.location - 1)
        } else {
            newStyles =  Set(getRichSpanStyleListByTextRange(selectedRange))
        }

        guard activeStyles != newStyles && selectedRange.location != 0 else { return }
        activeStyles = newStyles
        var attributes: [NSAttributedString.Key: Any] = [:]
        activeStyles.forEach({
            attributes[$0.attributedStringKey] = $0.defaultAttributeValue(font: currentFont)
        })

        headerType = activeStyles.first(where: { $0.isHeaderStyle })?.headerType ?? .default

        activeAttributes = attributes
    }
}

//MARK: - Add styles
extension RichEditorState {
    /**
     This will add style to the selected text
     - Parameters:
     - style: which is of type RichTextSpanStyle
     It will add style to the selected text if needed and set activeAttributes and activeStyle accordingly.
     */
    private func addStyle(_ style: RichTextSpanStyle) {
        guard !activeStyles.contains(style) else { return }
        activeStyles.insert(style)

        if (style.isHeaderStyle || style.isDefault || style.isList) {
            handleAddOrRemoveHeaderOrListStyle(in: selectedRange, style: style)
        } else if !selectedRange.isCollapsed {
            processSpansFor(new: style, in: selectedRange)
        }
    }

    /**
     This will add style to the range of text
     - Parameters:
     - style: which is of type RichTextSpanStyle
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
     - style: which is of type RichTextSpanStyle

     This will remove typing attributes as well for style.
     */
    private func removeStyle(_ style: RichTextSpanStyle) {
        guard activeStyles.contains(style) || style.isDefault else { return }
        activeStyles.remove(style)
        updateTypingAttributes()

        if style.isHeaderStyle || style.isDefault || style.isList {
            handleAddOrRemoveHeaderOrListStyle(in: selectedRange, style: style, byAdding: false)
        } else if !selectedRange.isCollapsed {
            processSpansFor(new: style, in: selectedRange, addStyle: false)
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
     - style:  which is of type of RichTextSpanStyle
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
    private func handleAddingCharacters(_ newValue: NSAttributedString) {
        let typedChars = newValue.string.utf16Length - rawText.utf16Length
        let startTypeIndex = selectedRange.location - typedChars
        let startTypeChar = newValue.string.utf16.map({ $0 })[startTypeIndex]

        if startTypeChar == "\n".utf16.first && startTypeChar == "\n".utf16.last,
           activeStyles.contains(where: { $0.isHeaderStyle }) {
            activeStyles.removeAll()
        }

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
    private func processSpan(_ richTextSpan: RichTextSpanInternal, typedChars: Int, startTypeIndex: Int, selectedStyles: inout Set<RichTextSpanStyle>, forward: Bool = false) {
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

    func divideSpanAndAddTextWithCurrentStyle(span: RichTextSpanInternal, typedChars: Int, startTypeIndex: Int, with styles: inout Set<RichTextSpanStyle>) {
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
    private func handleRemovingCharacters(_ newText: NSAttributedString) {
        guard !newText.string.isEmpty else {
            internalSpans.removeAll()
            activeStyles.removeAll()
            return
        }

        let removedCharsCount = rawText.utf16Length - newText.string.utf16Length
        let startRemoveIndex = selectedRange.location
        let endRemoveIndex = selectedRange.location + removedCharsCount - 1
        let removeRange = startRemoveIndex...endRemoveIndex
        let start = rawText.utf16.index(rawText.startIndex, offsetBy: startRemoveIndex)
        let end = rawText.utf16.index(rawText.startIndex, offsetBy: endRemoveIndex)

        if startRemoveIndex != endRemoveIndex, let newLineIndex = String(rawText[start...end]).map({ $0 }).lastIndex(of: "\n"), newLineIndex >= 0 {
            handleRemoveHeaderStyle(newText: newText.string, at: removeRange.nsRange, newLineIndex: newLineIndex)
        }

        let partsCopy = internalSpans

        let lowerBound = removeRange.lowerBound //- (selectedRange.length < removedCharsCount ? 1 : 0)

        for part in partsCopy {
            if let index = internalSpans.firstIndex(of: part) {
                if removeRange.upperBound < part.from {
                    internalSpans[index] = part.copy(from: part.from - (removedCharsCount), to: part.to - (removedCharsCount))
                } else if lowerBound <= part.from && removeRange.upperBound >= part.to {
                    internalSpans.removeAll(where: { $0 == part })
                } else if lowerBound <= part.from {
                    internalSpans[index] = part.copy(from: max(0, lowerBound), to: min(newText.string.utf16Length, part.to - removedCharsCount))
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
     - style: is of type RichTextSpanStyle
     */
    private func handleAddOrRemoveHeaderOrListStyle(in range: NSRange, style: RichTextSpanStyle, byAdding: Bool = true) {
        guard !rawText.isEmpty else { return }

        let range = style.isList ? getListRangeFor(range, in: rawText) : rawText.getHeaderRangeFor(range)
        processSpansFor(new: style, in: range, addStyle: byAdding)
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
     - styles: is of type [RichTextSpanStyle]
     - range: is of type NSRange
     */
    private func processSpansFor(new style: RichTextSpanStyle, in range: NSRange, addStyle: Bool = true) {
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

        var spansToUpdate = Set(getOverlappingSpans(for: range))

        if addStyle || style.isDefault {
            if style.isDefault {
                /// This will help to apply header style without loosing other style
                let span = RichTextSpanInternal(from: fromIndex, to: toIndex, attributes: style == .default ? .init(header: .default, align: .left) : getRichAttributesFor(style: style))
                spansToUpdate.insert(span)
            } else if !style.isHeaderStyle && !style.isList {
                ///When selected range's is surrounded with same styled text it helps to update selected text in editor
                let span = RichTextSpanInternal(from: fromIndex, to: max((toIndex - 1), 0), attributes: getRichAttributesFor(style: style))
                spansToUpdate.insert(span)
                spansToUpdate.insert(span)
            }
            applyStylesToSelectedText(spansToUpdate.map({ $0 }))

        } else {
            let span = RichTextSpanInternal(from: fromIndex, to: (toIndex - 1), attributes: getRichAttributesFor(style: style))
            removeAttributes([span])
            ///To apply style as remove span is removing other styles as well.
            applyStylesToSelectedText(spansToUpdate.map({ $0 }))
        }
    }

    private func processCompleteOverlappingSpans(_ spans: [RichTextSpanInternal], range: NSRange, style: RichTextSpanStyle, addStyle: Bool = true) -> [RichTextSpanInternal] {
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

    private func processPartialOverlappingSpans(_ spans: [RichTextSpanInternal], range: NSRange, style: RichTextSpanStyle, addStyle: Bool = true) -> [RichTextSpanInternal] {
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

    private func processSameSpans(_ spans: [RichTextSpanInternal], range: NSRange, style: RichTextSpanStyle, addStyle: Bool = true) -> [RichTextSpanInternal] {
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
    private func getListRangeFor(_ range: NSRange, in text: String) -> NSRange {
        guard !text.isEmpty else { return range }
        let lineRange = currentLine.lineRange

        guard !range.isCollapsed else { return lineRange }

        let fromIndex = range.lowerBound
        let toIndex = range.isCollapsed ? fromIndex : range.upperBound

        let newLineStartIndex = text.utf16.prefix(fromIndex).map({ $0 }).lastIndex(of: "\n".utf16.last) ?? 0
        let newLineEndIndex = text.utf16.suffix(from: text.utf16.index(text.utf16.startIndex, offsetBy: toIndex - 1)).map({ $0 }).firstIndex(of: "\n".utf16.last)

        ///Added +1 to start new line after \n otherwise it will create bullets for previous line as well
        let startIndex = max(0, (newLineStartIndex + 1))
        var endIndex = (toIndex - 1) + (newLineEndIndex ?? 0)

        if newLineEndIndex == nil {
            endIndex = (text.utf16Length)
        }

        let range = startIndex...endIndex
        return range.nsRange
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
        attributedString = NSMutableAttributedString(string: "")
    }

    /**
     This will provide Set of RichTextSpanStyle applied on given index
     - Parameters:
     - index: index or location of text
     */
    private func getRichSpanStyleByTextIndex(_ index: Int) -> Set<RichTextSpanStyle> {
        let styles = Set(internalSpans.filter { index >= $0.from && index <= $0.to }.map { $0.attributes?.styles() ?? []}.flatMap({ $0 }))
        return styles
    }

    /**
     This will provide Array of RichTextSpanStyle applied on given range
     - Parameters:
     - range: range of text which is of type NSRange
     */
    private func getRichSpanStyleListByTextRange(_ range: NSRange) -> [RichTextSpanStyle] {
        return internalSpans.filter({ range.closedRange.overlaps($0.closedRange) }).map { $0.attributes?.styles() ?? [] }.flatMap({ $0 })
    }
}

extension RichEditorState {
    func setInternalStyles(style: RichTextSpanStyle, add: Bool = true) {
        switch style {
        case .bold, .italic, .underline, .strikethrough:
            if let style = style.richTextStyle {
                setStyle(style, to: add)
            }
        case .h1, .h2, .h3, .h4, .h5, .h6, .default:
            actionPublisher.send(.setHeaderStyle(style))
        case .bullet(_):
            return
        case .size(let size):
            if let size, fontSize != CGFloat(size) {
                self.fontSize = CGFloat(size)
            }
        case .font(let fontName):
            if let fontName {
                self.fontName = fontName
            }
        case .color(let color):
            if let color {
                setColor(.foreground, to: .init(color))
            }
        case .background(let color):
            if let color {
                setColor(.background, to: .init(color))
            }
        case .align(let alignment):
            if let alignment, alignment != self.textAlignment {
                actionPublisher.send(.setAlignment(alignment))
            }
        }
    }
}
