//
//  RichTextView+Config.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import Foundation

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    extension RichTextView.Configuration {

        /// The standard rich text view configuration.
        ///
        /// You can set a new value to change the global default.
        public static var standard = Self()
    }
#endif
