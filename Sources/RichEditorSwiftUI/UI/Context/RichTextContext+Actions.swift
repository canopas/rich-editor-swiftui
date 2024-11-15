//
//  RichTextContext+Actions.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/10/24.
//

import SwiftUI

public extension RichEditorState {

    /// Handle a certain rich text action.
    func handle(_ action: RichTextAction) {
        switch action {
//        case .stepFontSize(let size):
//            fontSize += CGFloat(size)
//            updateStyle(style: .size(Int(fontSize)))
        default: actionPublisher.send(action)
        }
    }

    /// Check if the context can handle a certain action.
    func canHandle(_ action: RichTextAction) -> Bool {
        switch action {
        case .copy: canCopy
            //        case .pasteImage: true
            //        case .pasteImages: true
            //        case .pasteText: true
        case .print: false
        case .redoLatestChange: canRedoLatestChange
        case .undoLatestChange: canUndoLatestChange
        default: true
        }
    }

    /// Trigger a certain rich text action.
    func trigger(_ action: RichTextAction) {
        handle(action)
    }
}
