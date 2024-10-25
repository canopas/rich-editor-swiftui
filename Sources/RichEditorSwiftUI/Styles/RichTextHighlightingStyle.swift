//
//  RichTextHighlightingStyle.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import SwiftUI

/**
 This struct can be used to style rich text highlighting.
 */
public struct RichTextHighlightingStyle: Equatable, Hashable {

    /**
     Create a style instance.

     - Parameters:
     - backgroundColor: The background color to use for highlighted text.
     - foregroundColor: The foreground color to use for highlighted text.
     */
    public init(
        backgroundColor: Color = .clear,
        foregroundColor: Color = .accentColor
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    /// The background color to use for highlighted text.
    public let backgroundColor: Color

    /// The foreground color to use for highlighted text.
    public let foregroundColor: Color
}

public extension RichTextHighlightingStyle {

    /// The standard rich text highlighting style.
    ///
    /// You can set a new value to change the global default.
    static var standard = Self()
}
