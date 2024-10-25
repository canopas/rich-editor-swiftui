//
//  RichEditorState+UITextView.swift
//
//
//  Created by Divyesh Vekariya on 07/06/24.
//

import Foundation

#if canImport(UIKit)
import UIKit
extension RichEditorState {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        /// Handle newly added text according to our convenience

        // If the user just hit enter/newline
        if text == .newLine {
            let previousRange = NSRange(location: range.location > 1 ? (range.location - 2) : range.location, length: 0)
            if textView.text[previousRange.closedRange].string() == .newLine {
                if activeStyles.contains(where: { $0.isList }) {
                    endListStyle()
                    return false
                }
            }
        }
        //        else if text == .tab {
        //            if activeStyles.contains(where: { $0.isList }) {
        //                addSubList()
        //                return false
        //            }
        //        }

        return true
    }
}
#endif

#if canImport(AppKit)
import AppKit
extension RichEditorState {
    func textView(_ textView: NSTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        /// Handle newly added text according to our convenience

        // If the user just hit enter/newline
        if text == .newLine {
            let previousRange = NSRange(location: range.location > 1 ? (range.location - 2) : range.location, length: 0)
            if textView.string[previousRange.closedRange]
                .string() == .newLine {
                if activeStyles.contains(where: { $0.isList }) {
                    endListStyle()
                    return false
                }
            }
        }
        //        else if text == .tab {
        //            if activeStyles.contains(where: { $0.isList }) {
        //                addSubList()
        //                return false
        //            }
        //        }

        return true
    }
}
#endif

extension RichEditorState {
    func endListStyle() {
        if let itemToRemove = activeStyles.first(where: { $0.isList }), let listType = itemToRemove.listType {
            if listType.getIndent() <= 0 {
                toggleStyle(style: itemToRemove)
            }
//            else {
//                activeStyles.remove(itemToRemove)
//                toggleStyle(style: listType.moveIndentBackward().getTextSpanStyle())
//            }
        }
    }

//    func addSubList() {
//        if let listStyle = activeStyles.first(where: { $0.isList }) {
//            if let listType = listStyle.listType {
//                let newListStyle = listType.moveIndentForward().getTextSpanStyle()
//                activeStyles.remove(listStyle)
//                toggleStyle(style: newListStyle)
//            }
//        }
//    }
}
