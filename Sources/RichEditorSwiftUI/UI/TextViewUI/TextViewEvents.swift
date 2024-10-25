//
//  TextViewEvents.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 23/10/24.
//

import Foundation

//MARK: - TextView Events
public enum TextViewEvents {
    case didChangeSelection(selectedRange: NSRange, text: NSAttributedString)
    case didBeginEditing(selectedRange: NSRange, text: NSAttributedString)
    case didChange(selectedRange: NSRange, text: NSAttributedString)
    case didEndEditing(selectedRange: NSRange, text: NSAttributedString)
}
