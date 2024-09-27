//
//  Character+Extension.swift
//
//
//  Created by Divyesh Vekariya on 09/05/24.
//

import Foundation

extension Character {

    /// Check if a character is a new line separator.
    var isNewLineSeparator: Bool {
        self == .newLine || self == .carriageReturn
    }
}

