//
//  RichTextKeyboardToolbar.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-14.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/**
 This toolbar can be added above an iOS keyboard, to provide
 rich text formatting in a compact form.

 This toolbar is needed since the ``RichTextEditor`` can not
 use a `toolbar` modifier with `.keyboard` placement:

 ```swift
 RichTextEditor(text: $text, context: context)
     .toolbar {
         ToolbarItemGroup(placement: .keyboard) {
             ....
         }
     }
 ```

 Instead, add this toolbar below a ``RichTextEditor`` to let
 it automatically show when the text editor is edited in iOS.

 You can inject additional leading and trailing buttons, and
 customize the format sheet that is presented when users tap
 format button:

 ```swift
 VStack {
    RichTextEditor(...)
    RichTextKeyboardToolbar(
        context: context,
        leadingButtons: {},
        trailingButtons: {},
        formatSheet: { $0 }
    )
 }
 ```

 These view builders provide you with standard views. Return
 `$0` to use these standard views, or return any custom view
 that you want to use instead.

 You can configure and style the view by applying its config
 and style view modifiers to your view hierarchy:

 ```swift
 VStack {
    RichTextEditor(...)
    RichTextKeyboardToolbar(...)
 }
 .richTextKeyboardToolbarStyle(...)
 .richTextKeyboardToolbarConfig(...)
 ```

 For more information, see ``RichTextKeyboardToolbarConfig``
 and ``RichTextKeyboardToolbarStyle``.
 */
public struct RichTextKeyboardToolbar<LeadingButtons: View, TrailingButtons: View, FormatSheet: View>: View {

    /**
     Create a rich text keyboard toolbar.

     - Parameters:
       - context: The context to affect.
       - leadingButtons: The leading buttons to place after the leading actions.
       - trailingButtons: The trailing buttons to place before the trailing actions.
       - formatSheet: The rich text format sheet to use, by default ``RichTextFormat/Sheet``.
     */
    public init(
        context: RichEditorState,
        @ViewBuilder leadingButtons: @escaping (StandardLeadingButtons) -> LeadingButtons,
        @ViewBuilder trailingButtons: @escaping (StandardTrailingButtons) -> TrailingButtons,
        @ViewBuilder formatSheet: @escaping (StandardFormatSheet) -> FormatSheet
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.leadingButtons = leadingButtons
        self.trailingButtons = trailingButtons
        self.formatSheet = formatSheet
    }

    public typealias StandardLeadingButtons = EmptyView
    public typealias StandardTrailingButtons = EmptyView
    public typealias StandardFormatSheet = RichTextFormat.Sheet

    private let leadingButtons: (StandardLeadingButtons) -> LeadingButtons
    private let trailingButtons: (StandardTrailingButtons) -> TrailingButtons
    private let formatSheet: (StandardFormatSheet) -> FormatSheet

    @ObservedObject
    private var context: RichEditorState

    @State
    private var isFormatSheetPresented = false

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    @Environment(\.richTextKeyboardToolbarConfig)
    private var config

    @Environment(\.richTextKeyboardToolbarStyle)
    private var style

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: style.itemSpacing) {
                leadingViews
                Spacer()
                trailingViews
            }
            .padding(10)
        }
        .environment(\.sizeCategory, .medium)
        .frame(height: style.toolbarHeight)
        .overlay(Divider(), alignment: .bottom)
        .accentColor(.primary)
        .background(
            Color.primary.colorInvert()
                .overlay(Color.white.opacity(0.2))
                .shadow(color: style.shadowColor, radius: style.shadowRadius, x: 0, y: 0)
        )
        .opacity(shouldDisplayToolbar ? 1 : 0)
        .offset(y: shouldDisplayToolbar ? 0 : style.toolbarHeight)
        .frame(height: shouldDisplayToolbar ? nil : 0)
        .sheet(isPresented: $isFormatSheetPresented) {
            formatSheet(
                .init(context: context)
            )
            .prefersMediumSize()
        }
    }
}

private extension View {

    @ViewBuilder
    func prefersMediumSize() -> some View {
        #if macOS
        self
        #else
        if #available(iOS 16, *) {
            self.presentationDetents([.medium])
        } else {
            self
        }
        #endif
    }
}

private extension RichTextKeyboardToolbar {

    var isCompact: Bool {
        horizontalSizeClass == .compact
    }
}

private extension RichTextKeyboardToolbar {

    var divider: some View {
        Divider()
            .frame(height: 25)
    }

    @ViewBuilder
    var leadingViews: some View {
        RichTextAction.ButtonStack(
            context: context,
            actions: config.leadingActions,
            spacing: style.itemSpacing
        )

        leadingButtons(StandardLeadingButtons())

        divider

        Button(action: presentFormatSheet) {
            Image.richTextFormat
                .contentShape(Rectangle())
        }

        RichTextStyle.ToggleStack(context: context)
            .keyboardShortcutsOnly(if: isCompact)

        RichTextFont.SizePickerStack(context: context)
            .keyboardShortcutsOnly()
    }

    @ViewBuilder
    var trailingViews: some View {
        RichTextAlignment.Picker(selection: $context.textAlignment)
            .pickerStyle(.segmented)
            .frame(maxWidth: 200)
            .keyboardShortcutsOnly(if: isCompact)

        trailingButtons(StandardTrailingButtons())

        RichTextAction.ButtonStack(
            context: context,
            actions: config.trailingActions,
            spacing: style.itemSpacing
        )
    }
}

private extension View {

    @ViewBuilder
    func keyboardShortcutsOnly(
        if condition: Bool = true
    ) -> some View {
        if condition {
            self.hidden()
                .frame(width: 0)
        } else {
            self
        }
    }
}

private extension RichTextKeyboardToolbar {

    var shouldDisplayToolbar: Bool { context.isEditingText || config.alwaysDisplayToolbar }
}

private extension RichTextKeyboardToolbar {

    func presentFormatSheet() {
        isFormatSheetPresented = true
    }
}
#endif
