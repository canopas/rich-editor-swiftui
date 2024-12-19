//
//  RichTextFont+PickerConfig.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/11/24.
//

import SwiftUI

extension RichTextFont {

    /// This type can configure a ``RichTextFont/Picker``.
    ///
    /// This configuration contains configuration properties
    /// for many different font pickers types. Some of these
    /// properties are not used in some pickers.
    public struct PickerConfig {

        /// Create a custom font picker config.
        ///
        /// - Parameters:
        ///   - fonts: The fonts to display in the list, by default `all`.
        ///   - fontSize: The font size to use in the list items, by default `20`.
        ///   - dismissAfterPick: Whether or not to dismiss the picker after a font is selected, by default `false`.
        ///   - moveSelectionTopmost: Whether or not to place the selected font topmost, by default `true`.
        public init(
            fonts: [RichTextFont.PickerFont] = .all,
            fontSize: CGFloat = 20,
            dismissAfterPick: Bool = false,
            moveSelectionTopmost: Bool = true
        ) {
            self.fonts = fonts
            self.fontSize = fontSize
            self.dismissAfterPick = dismissAfterPick
            self.moveSelectionTopmost = moveSelectionTopmost
        }

        public typealias Font = RichTextFont.PickerFont
        public typealias FontName = String

        /// The fonts to display in the list.
        public var fonts: [RichTextFont.PickerFont]

        /// The font size to use in the list items.
        public var fontSize: CGFloat

        /// Whether or not to dismiss the picker after a font is selected.
        public var dismissAfterPick: Bool

        /// Whether or not to move the selected font topmost
        public var moveSelectionTopmost: Bool
    }
}

extension RichTextFont.PickerConfig {

    /// The standard font picker configuration.
    public static var standard: Self { .init() }
}

extension RichTextFont.PickerConfig {

    /// The fonts to list for a given selection.
    public func fontsToList(for selection: FontName) -> [Font] {
        if moveSelectionTopmost {
            return fonts.moveTopmost(selection)
        } else {
            return fonts
        }
    }
}

extension View {

    /// Apply a ``RichTextFont`` picker configuration.
    public func richTextFontPickerConfig(
        _ config: RichTextFont.PickerConfig
    ) -> some View {
        self.environment(\.richTextFontPickerConfig, config)
    }
}

extension RichTextFont.PickerConfig {

    fileprivate struct Key: EnvironmentKey {

        public static var defaultValue: RichTextFont.PickerConfig {
            .standard
        }
    }
}

extension EnvironmentValues {

    /// This value can bind to a font picker config.
    public var richTextFontPickerConfig: RichTextFont.PickerConfig {
        get { self[RichTextFont.PickerConfig.Key.self] }
        set { self[RichTextFont.PickerConfig.Key.self] = newValue }
    }
}
