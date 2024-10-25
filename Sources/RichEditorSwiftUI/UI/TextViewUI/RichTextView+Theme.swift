//
//  RichTextView+Theme.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

public extension RichTextView {

    /**
     This type can be used to configure a ``RichTextEditor``'s current color properties.
     */
    struct Theme {

        /**
         Create a custom configuration.

         - Parameters:
         - font: default `.systemFont` of point size `16` (this differs on iOS and macOS).
         - fontColor: default `.textColor`.
         - backgroundColor: Color of whole textView default `.clear`.
         */
        public init(
            font: FontRepresentable = .systemFont(ofSize: 16),
            fontColor: ColorRepresentable = .textColor,
            backgroundColor: ColorRepresentable = .clear
        ) {
            self.font = font
            self.fontColor = fontColor
            self.backgroundColor = backgroundColor
        }

        public let font: FontRepresentable
        public let fontColor: ColorRepresentable
        public let backgroundColor: ColorRepresentable
    }
}

public extension RichTextView.Theme {

    /// The standard rich text view theme.
    ///
    /// You can set a new value to change the global default.
    static var standard = Self()
}
#endif

