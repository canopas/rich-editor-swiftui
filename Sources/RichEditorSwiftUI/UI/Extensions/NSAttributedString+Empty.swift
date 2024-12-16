//
//  NSAttributedString+Empty.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 13/12/24.
//

import Foundation

public extension NSAttributedString {

    /// Create an empty attributed string.
    static var empty: NSAttributedString {
        .init(string: "")
    }
}
