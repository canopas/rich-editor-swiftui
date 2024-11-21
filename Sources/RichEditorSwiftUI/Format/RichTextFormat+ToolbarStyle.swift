//
//  RichTextFormat+ToolbarStyle.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/11/24.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFormat {

    /// This type can be used to style a format toolbar.
    struct ToolbarStyle {

        public init(
            padding: Double = 10,
            spacing: Double = 10
        ) {
            self.padding = padding
            self.spacing = spacing
        }

        public var padding: Double
        public var spacing: Double
    }
}

public extension RichTextFormat.ToolbarStyle {

    /// The standard rich text format toolbar style.
    static var standard: Self { .init() }
}

public extension View {

    /// Apply a rich text format toolbar style.
    func richTextFormatToolbarStyle(
        _ style: RichTextFormat.ToolbarStyle
    ) -> some View {
        self.environment(\.richTextFormatToolbarStyle, style)
    }
}

private extension RichTextFormat.ToolbarStyle {

    struct Key: EnvironmentKey {

        public static var defaultValue: RichTextFormat.ToolbarStyle {
            .standard
        }
    }
}

public extension EnvironmentValues {

    /// This value can bind to a format toolbar style.
    var richTextFormatToolbarStyle: RichTextFormat.ToolbarStyle {
        get { self [RichTextFormat.ToolbarStyle.Key.self] }
        set { self [RichTextFormat.ToolbarStyle.Key.self] = newValue }
    }
}
#endif
