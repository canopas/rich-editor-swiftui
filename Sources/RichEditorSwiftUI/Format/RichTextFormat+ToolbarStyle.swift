//
//  RichTextFormat+ToolbarStyle.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/11/24.
//

#if os(iOS) || os(macOS) || os(visionOS)
    import SwiftUI

    extension RichTextFormat {

        /// This type can be used to style a format toolbar.
        public struct ToolbarStyle {

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

    extension RichTextFormat.ToolbarStyle {

        /// The standard rich text format toolbar style.
        public static var standard: Self { .init() }
    }

    extension View {

        /// Apply a rich text format toolbar style.
        public func richTextFormatToolbarStyle(
            _ style: RichTextFormat.ToolbarStyle
        ) -> some View {
            self.environment(\.richTextFormatToolbarStyle, style)
        }
    }

    extension RichTextFormat.ToolbarStyle {

        fileprivate struct Key: EnvironmentKey {

            public static var defaultValue: RichTextFormat.ToolbarStyle {
                .standard
            }
        }
    }

    extension EnvironmentValues {

        /// This value can bind to a format toolbar style.
        public var richTextFormatToolbarStyle: RichTextFormat.ToolbarStyle {
            get { self[RichTextFormat.ToolbarStyle.Key.self] }
            set { self[RichTextFormat.ToolbarStyle.Key.self] = newValue }
        }
    }
#endif
