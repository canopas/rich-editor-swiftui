//
//  RichEditorUndoManager.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 03/01/25.
//

import SwiftUI

/// Manages undo and redo operations for a rich text editor.
internal class RichEditorUndoManager {

  /// Stores redoable operations.
  private var redoOperations: [RichTextOperation] = []

  /// Stores undoable operations.
  private var undoOperations: [RichTextOperation] = []

  /// Checks if there are operations available to undo.
  /// - Returns: `true` if there are undo operations, otherwise `false`.
  func canUndo() -> Bool {
    !undoOperations.isEmpty
  }

  /// Checks if there are operations available to redo.
  /// - Returns: `true` if there are redo operations, otherwise `false`.
  func canRedo() -> Bool {
    !redoOperations.isEmpty
  }

  /// Performs the undo operation by moving the last undo operation to the redo stack.
  /// - Returns: The undone `RichTextOperation`, or `nil` if no undo operations are available.
  func undo() -> RichTextOperation? {
    guard let last = undoOperations.popLast() else { return nil }
    redoOperations.append(last)
    return last
  }

  /// Performs the redo operation by moving the last redo operation to the undo stack.
  /// - Returns: The redone `RichTextOperation`, or `nil` if no redo operations are available.
  func redo() -> RichTextOperation? {
    guard let last = redoOperations.popLast() else { return nil }
    undoOperations.append(last)
    return last
  }

  /// Clears all undo and redo operations.
  func reset() {
    undoOperations.removeAll()
    redoOperations.removeAll()
  }

  /// Registers a new undo operation.
  /// - Parameter operation: The `RichTextOperation` to add to the undo stack.
  /// - Note: Clears the redo stack when a new undo operation is registered.
  func registerUndoOperation(_ operation: RichTextOperation) {
    if !redoOperations.isEmpty {
      redoOperations.removeAll()
    }
    undoOperations.append(operation)
  }
}
