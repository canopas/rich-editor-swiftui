//
//  RichTextEditor+Config.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    import SwiftUI

    /// This struct be used to configure a ``RichTextEditor``.
    public typealias RichTextEditorConfig = RichTextView.Configuration

    extension View {

        /// Apply a ``RichTextEditor`` configuration.
        public func richTextEditorConfig(
            _ config: RichTextEditorConfig
        ) -> some View {
            self.environment(\.richTextEditorConfig, config)
        }
    }

    extension RichTextEditorConfig {

        fileprivate struct Key: EnvironmentKey {

            public static var defaultValue: RichTextEditorConfig = .standard
        }
    }

    extension EnvironmentValues {

        /// This value can bind to a rich text editor config.
        public var richTextEditorConfig: RichTextEditorConfig {
            get { self[RichTextEditorConfig.Key.self] }
            set { self[RichTextEditorConfig.Key.self] = newValue }
        }
    }
#endif
