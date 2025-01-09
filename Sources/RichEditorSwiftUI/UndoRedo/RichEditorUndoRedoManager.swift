//
//  File.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 03/01/25.
//

import Foundation

internal class RichEditorUndoRedoManager {
  var redoOperations: [RichTextOperation] = []
  var undoOperations: [RichTextOperation] = []

  func canUndo() -> Bool {
    !undoOperations.isEmpty
  }

  func canRedo() -> Bool {
    !redoOperations.isEmpty
  }

  func undo() -> RichTextOperation? {
    guard let last = undoOperations.popLast() else { return nil }
    redoOperations.append(last)
    return last
  }

  func redo() -> RichTextOperation? {
    guard let last = redoOperations.popLast() else { return nil }
    undoOperations.append(last)
    return last
  }

  func getPreviousAttributes() -> OperationAttributes {
    guard let last = undoOperations.last else { return getDefaultAttributes() }
    return last.attributes
  }

  func getPreviousRange() -> NSRange? {
    guard let last = undoOperations.last else { return nil }
    return last.range
  }

  func registerUndoOperation(_ operation: RichTextOperation) {
    if !redoOperations.isEmpty {
      redoOperations.removeAll()
    }
    undoOperations.append(operation)
  }

  private func getDefaultAttributes() -> OperationAttributes {
    return OperationAttributes(
      activeStyles: [],
      headerType: .default,
      textAlignment: .left,
      fontName: "",
      fontSize: .standardRichTextFontSize,
      colors: [:],
      lineSpacing: 10,
      paragraphStyle: .default,
      styles: [:],
      link: nil)
  }
}
