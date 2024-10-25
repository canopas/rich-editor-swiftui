//
//  RichTextEditor+Config.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

/// This struct be used to configure a ``RichTextEditor``.
public typealias RichTextEditorConfig = RichTextView.Configuration

public extension View {

    /// Apply a ``RichTextEditor`` configuration.
    func richTextEditorConfig(
        _ config: RichTextEditorConfig
    ) -> some View {
        self.environment(\.richTextEditorConfig, config)
    }
}

private extension RichTextEditorConfig {

    struct Key: EnvironmentKey {

        public static var defaultValue: RichTextEditorConfig = .standard
    }
}

public extension EnvironmentValues {

    /// This value can bind to a rich text editor config.
    var richTextEditorConfig: RichTextEditorConfig {
        get { self [RichTextEditorConfig.Key.self] }
        set { self [RichTextEditorConfig.Key.self] = newValue }
    }
}
#endif

