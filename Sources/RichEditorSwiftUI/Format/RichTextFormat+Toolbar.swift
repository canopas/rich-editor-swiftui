//
//  RichTextFormat+Toolbar.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/11/24.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFormat {

    /**
     This horizontal toolbar provides text format controls.

     This toolbar adapts the layout based on horizontal size
     class. The control row is split in two for compact size,
     while macOS and regular sizes get a single row.

     You can configure and style the view by applying config
     and style view modifiers to your view hierarchy:

     ```swift
     VStack {
     ...
     }
     .richTextFormatToolbarStyle(...)
     .richTextFormatToolbarConfig(...)
     ```
     */
    struct Toolbar: RichTextFormatToolbarBase {

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

        @ObservedObject
        private var context: RichEditorState

        @Environment(\.richTextFormatToolbarConfig)
        var config

        @Environment(\.richTextFormatToolbarStyle)
        var style

        @Environment(\.horizontalSizeClass)
        private var horizontalSizeClass

        public var body: some View {
            VStack(spacing: style.spacing) {
                controls
                if hasColorPickers {
                    Divider()
                    colorPickers(for: context)
                }
            }
            .labelsHidden()
            .padding(.vertical, style.padding)
            .environment(\.sizeCategory, .medium)
//            .background(background)
            #if macOS
            .frame(minWidth: 650)
            #endif
        }
    }
}

// MARK: - Views

private extension RichTextFormat.Toolbar {

    var useSingleLine: Bool {
        #if macOS
        true
        #else
        horizontalSizeClass == .regular
        #endif
    }
}

private extension RichTextFormat.Toolbar {

    var background: some View {
        Color.clear
            .overlay(Color.primary.opacity(0.1))
            .shadow(color: .black.opacity(0.1), radius: 5)
            .edgesIgnoringSafeArea(.all)
    }

    @ViewBuilder
    var controls: some View {
        if useSingleLine {
            HStack {
                controlsContent
            }
            .padding(.horizontal, style.padding)
        } else {
            VStack(spacing: style.spacing) {
                controlsContent
            }
            .padding(.horizontal, style.padding)
        }
    }

    @ViewBuilder
    var controlsContent: some View {
        HStack {
            #if macOS
            fontPicker(value: $context.fontName)
                .onChangeBackPort(of: context.fontName) { newValue in
                    context.updateStyle(style: .font(newValue))
                }
            #endif
            styleToggleGroup(for: context)
            if !useSingleLine {
                Spacer()
            }
            fontSizePicker(for: context)
            if horizontalSizeClass == .regular {
                Spacer()
            }
        }
        HStack {
            alignmentPicker(value: $context.textAlignment)
//            superscriptButtons(for: context, greedy: false)
//            indentButtons(for: context, greedy: false)
        }
    }
}
#endif
