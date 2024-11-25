//
//  RichTextFormat+Sidebar.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/11/24.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFormat {

    /**
     This sidebar view provides various text format options, and
     is meant to be used on macOS, in a trailing sidebar.

     You can configure and style the view by applying its config
     and style view modifiers to your view hierarchy:

     ```swift
     VStack {
     ...
     }
     .richTextFormatSidebarStyle(...)
     .richTextFormatSidebarConfig(...)
     ```

     > Note: The sidebar is currently designed for macOS, but it
     should also be made to look good on iPadOS in landscape, to
     let us use it instead of the ``RichTextFormat/Sheet``.
     */
    struct Sidebar: RichTextFormatToolbarBase {

        /**
         Create a rich text format sheet.

         - Parameters:
         - context: The context to apply changes to.
         */
        public init(
            context: RichEditorState
        ) {
            self._context = ObservedObject(wrappedValue: context)
        }

        public typealias Config = RichTextFormat.ToolbarConfig
        public typealias Style = RichTextFormat.ToolbarStyle

        @ObservedObject
        private var context: RichEditorState

        @Environment(\.richTextFormatSidebarConfig)
        var config

        @Environment(\.richTextFormatSidebarStyle)
        var style

        public var body: some View {
            VStack(alignment: .leading, spacing: style.spacing) {
                SidebarSection {
                    fontPicker(value: $context.fontName)
                        .onChangeBackPort(of: context.fontName) { newValue in
                            context.updateStyle(style: .font(newValue))
                        }
                    HStack {
                        styleToggleGroup(for: context)
                        Spacer()
                        fontSizePicker(for: context)
                    }
                }

                Divider()

                SidebarSection {
                    alignmentPicker(value: $context.textAlignment)
                        .onChangeBackPort(of: context.textAlignment) { newValue in
                            context.updateStyle(style: .align(newValue))
                        }
//                    HStack {
//                        lineSpacingPicker(for: context)
//                    }
//                    HStack {
//                        indentButtons(for: context, greedy: true)
//                        superscriptButtons(for: context, greedy: true)
//                    }
                }

                Divider()

                if hasColorPickers {
                    SidebarSection {
                        colorPickers(for: context)
                    }
                    .padding(.trailing, -8)
                    Divider()
                }

                Spacer()
            }
            .labelsHidden()
            .padding(style.padding - 2)
            .background(Color.white.opacity(0.05))
        }
    }
}

private struct SidebarSection<Content: View>: View {

    @ViewBuilder
    let content: () -> Content

    @Environment(\.richTextFormatToolbarStyle)
    var style

    var body: some View {
        VStack(alignment: .leading, spacing: style.spacing) {
            content()
        }
    }
}

public extension View {

    /// Apply a rich text format sidebar config.
    func richTextFormatSidebarConfig(
        _ value: RichTextFormat.Sidebar.Config
    ) -> some View {
        self.environment(\.richTextFormatSidebarConfig, value)
    }

    /// Apply a rich text format sidebar style.
    func richTextFormatSidebarStyle(
        _ value: RichTextFormat.Sidebar.Style
    ) -> some View {
        self.environment(\.richTextFormatSidebarStyle, value)
    }
}

private extension RichTextFormat.Sidebar.Config {

    struct Key: EnvironmentKey {

        static var defaultValue: RichTextFormat.Sidebar.Config {
            .standard
        }
    }
}

private extension RichTextFormat.Sidebar.Style {

    struct Key: EnvironmentKey {

        static var defaultValue: RichTextFormat.Sidebar.Style {
            .standard
        }
    }
}

public extension EnvironmentValues {

    /// This value can bind to a format sidebar config.
    var richTextFormatSidebarConfig: RichTextFormat.Sidebar.Config {
        get { self [RichTextFormat.Sidebar.Config.Key.self] }
        set { self [RichTextFormat.Sidebar.Config.Key.self] = newValue }
    }

    /// This value can bind to a format sidebar style.
    var richTextFormatSidebarStyle: RichTextFormat.Sidebar.Style {
        get { self [RichTextFormat.Sidebar.Style.Key.self] }
        set { self [RichTextFormat.Sidebar.Style.Key.self] = newValue }
    }
}
#endif
