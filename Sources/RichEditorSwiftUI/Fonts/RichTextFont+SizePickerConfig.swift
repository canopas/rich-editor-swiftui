//
//  RichTextFont+SizePickerConfig.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/10/24.
//

import SwiftUI

public extension RichTextFont {

    /// This type can configure a ``RichTextFont/SizePicker``.
    struct SizePickerConfig {

        /// Create a custom font size picker config.
        ///
        /// - Parameters:
        ///   - values: The values to display in the list, by default a standard list.
        public init(
            values: [CGFloat] = [10, 12, 14, 16, 18, 20, 22, 24, 28, 36, 48, 64, 72, 96, 144]
        ) {
            self.values = values
        }

        /// The values to display in the list.
        public var values: [CGFloat]
    }
}

public extension RichTextFont.SizePickerConfig {

    /// The standard font size picker configuration.
    ///
    /// You can set a new value to change the global default.
    static var standard = Self()
}

public extension View {

    /// Apply a ``RichTextFont`` size picker configuration.
    func richTextFontSizePickerConfig(
        _ config: RichTextFont.SizePickerConfig
    ) -> some View {
        self.environment(\.richTextFontSizePickerConfig, config)
    }
}

private extension RichTextFont.SizePickerConfig {

    struct Key: EnvironmentKey {

        public static var defaultValue: RichTextFont.SizePickerConfig = .standard
    }
}

public extension EnvironmentValues {

    /// This value can bind to a font size picker config.
    var richTextFontSizePickerConfig: RichTextFont.SizePickerConfig {
        get { self [RichTextFont.SizePickerConfig.Key.self] }
        set { self [RichTextFont.SizePickerConfig.Key.self] = newValue }
    }
}
