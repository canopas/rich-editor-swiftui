//
//  NSAttributedString+Empty.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 13/12/24.
//

import Foundation

extension NSAttributedString {

    /// Create an empty attributed string.
    public static var empty: NSAttributedString {
        .init(string: "")
    }
}
