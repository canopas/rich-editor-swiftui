//
//  RichEditorState+UITextView.swift
//
//
//  Created by Divyesh Vekariya on 07/06/24.
//

import Foundation
import UIKit

extension RichEditorState {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        /// Handle newly added text according to our convenience

        // If the user just hit enter/newline
        if text == "\n" {
            let previousRange = NSRange(location: range.location > 1 ? (range.location - 2) : range.location, length: 0)
            if textView.text[previousRange.closedRange] == "\n" {
                if activeStyles.contains(where: { $0.isList }) {
                    endListStyle()
                    return false
                }
            }
        }

        return true
    }

    func endListStyle() {
        if let itemToRemove = activeStyles.first(where: { $0.isList }) {
            toggleStyle(style: itemToRemove)
        }
    }
}
