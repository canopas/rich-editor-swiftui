//
//  RichEditorState+UndoRedoManager.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 06/01/25.
//

import Foundation

extension RichEditorState {
  func updateUndoRedoState() {
    canUndoLatestChange = undoManager.canUndo()
    canRedoLatestChange = undoManager.canRedo()
  }

  func observerTextInput() {
    $attributedString
      .dropFirst()
      .drop(while: { _ in !self.isOperationIsFromUser })
      .debounce(for: .milliseconds(700), scheduler: DispatchQueue.main)
      .sink { [weak self] attributedText in
        guard let self = self else { return }
        //                let operation = self.getOperationForTextChange(self.attributedString, rawText: self.rawText)
        //                if let operation {
        //                    self.undoManager.registerUndoOperation(operation)
        //                }
        //                self.isOperationIsFromUser = false
        //                self.operationRawText = self.attributedString.string
        updateUndoRedoState()
      }
      .store(in: &cancellables)
  }

  func redoLastChanges() {
    guard let lastOperation = undoManager.redo() else { return }
    restoreState(for: lastOperation, isRedo: true)
    updateUndoRedoState()
  }

  func undoLastChanges() {
    guard let lastOperation = undoManager.undo() else { return }
    restoreState(for: lastOperation, isRedo: false)
    updateUndoRedoState()
  }

  private func restoreState(for operation: RichTextOperation, isRedo: Bool) {
    setSelectedRange(range: operation.range)
    if isRedo {
      setCurrentAttributes(attributes: operation.attributes)
    }

    switch operation.operationType {
    case .addOrRemoveText(_, let rawText, _):
      //            let shouldAdd = isRedo ? isAdded : !isAdded
      self.isOperationIsFromUser = false
      actionPublisher.send(.setAttributedString(attributedString))
      self.rawText = rawText
    //            let attributedText = getAttributedStringBy(adding: shouldAdd, chars: rawText, at: operation.range.location)
    //            self.attributedString = attributedText
    //            onTextFieldValueChange(newText: attributedText, selection: operation.range)
    //            self.operationRawText = attributedString.string

    case .addOrRemoveStyle(let style, let isAdded):
      let shouldAdd = isRedo ? isAdded : !isAdded
      if shouldAdd {
        activeStyles.remove(style)
      } else {
        activeStyles.insert(style)
      }
      toggleStyle(style: style, shouldRegisterUndo: false)

    case .setStyleStyle(let previousStyle, let newStyle, _):
      if let previousStyle {
        updateStyle(style: isRedo ? newStyle : previousStyle, shouldRegisterUndo: false)
      } else {
        updateStyle(style: newStyle, shouldRegisterUndo: false)
      }
    }

    if !isRedo {
      setCurrentAttributes(attributes: undoManager.getPreviousAttributes())
    }

    updateUndoRedoState()
  }

  private func setSelectedRange(range: NSRange) {
    actionPublisher.send(.selectRange(range))
    selectedRange = range
  }
  private func setCurrentAttributes(attributes: OperationAttributes) {
    activeStyles = attributes.activeStyles
    headerType = attributes.headerType
    textAlignment = attributes.textAlignment
    fontName = attributes.fontName
    fontSize = attributes.fontSize
    colors = attributes.colors
    lineSpacing = attributes.lineSpacing
    paragraphStyle = attributes.paragraphStyle
    //        styles = attributes.styles
    link = attributes.link
  }

  func getAttributedStringBy(adding: Bool, chars: String, at index: Int)
    -> NSMutableAttributedString
  {
    let attributedString = NSMutableAttributedString(attributedString: self.attributedString)
    let attributedText = NSAttributedString(string: chars)

    if adding {
      attributedString.insert(attributedText, at: index)
    } else {
      let range = NSRange(location: index, length: chars.utf16Length)
      attributedString.replaceCharacters(in: range, with: "")
    }

    return attributedString
  }

  func getOperationForTextChange(_ newText: NSAttributedString, rawText: String)
    -> RichTextOperation?
  {
    let isAdded = newText.string.utf16Length > rawText.utf16Length
    let range = NSRange(
      location: isAdded ? selectedRange.lowerBound : selectedRange.upperBound, length: 0)
    return RichTextOperation(
      operationType: .addOrRemoveText(newText: newText, rawText: rawText, isAdded: isAdded),
      range: range,
      attributes: getCurrentAttributes()
    )
  }

  func getOperationFor(style: RichTextSpanStyle, isAdded: Bool) -> RichTextOperation {
    return RichTextOperation(
      operationType: .addOrRemoveStyle(style: style, isAdded: isAdded),
      range: selectedRange,
      attributes: getCurrentAttributes()
    )
  }

  func registerOperationForText(newText: NSAttributedString, rawText: String) {
    guard isOperationIsFromUser,
      let operation = getOperationForTextChange(newText, rawText: rawText)
    else { return }
    undoManager.registerUndoOperation(operation)
    updateUndoRedoState()
  }

  func getOperationForSetStyle(
    previousStyle: RichTextSpanStyle?, newStyle: RichTextSpanStyle, isSet: Bool
  ) -> RichTextOperation {
    return RichTextOperation(
      operationType: .setStyleStyle(previousStyle: previousStyle, newStyle: newStyle, isSet: isSet),
      range: selectedRange,
      attributes: getCurrentAttributes()
    )
  }

  //    func getAddedOrRemovedTextFor(_ newText: NSAttributedString, rawText: String) -> String? {
  //        if newText.string.utf16Length > rawText.utf16Length {
  //            let addedCharsCount = newText.string.utf16Length - rawText.utf16Length
  //            let startIndex = selectedRange.location - addedCharsCount
  //            let range = NSRange(location: startIndex, length: addedCharsCount)
  //            return newText.string[range.closedRange].string()
  //        } else if rawText.utf16Length > newText.string.utf16Length {
  //            let removedCharsCount = rawText.utf16Length - newText.string.utf16Length
  //            let range = NSRange(location: selectedRange.location, length: removedCharsCount)
  //            return rawText[range.closedRange].string()
  //        }
  //        return nil
  //    }

  func registerUndoFor(style: RichTextSpanStyle, isAdded: Bool) {
    let operation = getOperationFor(style: style, isAdded: isAdded)
    undoManager.registerUndoOperation(operation)
    updateUndoRedoState()
  }

  func registerUndoForSetStyle(previousStyle: RichTextSpanStyle?, newStyle: RichTextSpanStyle) {
    let operation = getOperationForSetStyle(
      previousStyle: previousStyle, newStyle: newStyle, isSet: true)
    undoManager.registerUndoOperation(operation)
    updateUndoRedoState()
  }

  private func getCurrentAttributes() -> OperationAttributes {
    return OperationAttributes(
      activeStyles: activeStyles,
      headerType: headerType,
      textAlignment: textAlignment,
      fontName: fontName,
      fontSize: fontSize,
      colors: colors,
      lineSpacing: lineSpacing,
      paragraphStyle: paragraphStyle,
      styles: styles,
      link: link
    )
  }
}
