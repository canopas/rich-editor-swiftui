//
//  RichTextEditor+Style.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    import SwiftUI

    /// This struct can be used to style a ``RichTextEditor``.
    public typealias RichTextEditorStyle = RichTextView.Theme

    extension View {

        /// Apply a ``RichTextEditor`` style.
        public func richTextEditorStyle(
            _ style: RichTextEditorStyle
        ) -> some View {
            self.environment(\.richTextEditorStyle, style)
        }
    }

    extension RichTextEditorStyle {

        fileprivate struct Key: EnvironmentKey {

            static var defaultValue: RichTextEditorStyle = .standard
        }
    }

    extension EnvironmentValues {

        /// This value can bind to a rich text editor style.
        public var richTextEditorStyle: RichTextEditorStyle {
            get { self[RichTextEditorStyle.Key.self] }
            set { self[RichTextEditorStyle.Key.self] = newValue }
        }
    }
#endif
