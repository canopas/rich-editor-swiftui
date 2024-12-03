//
//  RichTextCoordinator.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//
#if iOS || macOS || os(tvOS) || os(visionOS)
import Combine
import SwiftUI

/**
 This coordinator is used to keep a ``RichTextView`` in sync
 with a ``RichEditorState``.

 This is used by ``RichTextEditor`` to coordinate changes in
 its context and the underlying text view.

 The coordinator sets itself as the text view's delegate. It
 updates the context when things change in the text view and
 syncs to context changes to the text view.
 */
open class RichTextCoordinator: NSObject {

    // MARK: - Properties

    /// The rich text context to coordinate with.
    public let context: RichEditorState

    /// The rich text to edit.
    public var text: Binding<NSAttributedString>

    /// The text view for which the coordinator is used.
    public private(set) var textView: RichTextView

    /// This set is used to store context observations.
    public var cancellables = Set<AnyCancellable>()

    /// This flag is used to avoid delaying context sync.
    var shouldDelaySyncContextWithTextView = false

    // MARK: - Internal Properties

    /**
     The background color that was used before the currently
     highlighted range was set.
     */
    var highlightedRangeOriginalBackgroundColor: ColorRepresentable?

    /**
     The foreground color that was used before the currently
     highlighted range was set.
     */
    var highlightedRangeOriginalForegroundColor: ColorRepresentable?

    private var cancellable: Set<AnyCancellable> = []

    // MARK: - Initialization

    /**
     Create a rich text coordinator.

     - Parameters:
     - text: The rich text to edit.
     - textView: The rich text view to keep in sync.
     - richEditorState: The context to keep in sync.
     */
    public init(
        text: Binding<NSAttributedString>,
        textView: RichTextView,
        richTextContext: RichEditorState
    ) {
        textView.attributedString = text.wrappedValue
        self.text = text
        self.textView = textView
        self.context = richTextContext
        super.init()
        self.textView.delegate = self
        subscribeToUserActions()

//                observerAttributes()
    }
#if canImport(UIKit)

    // MARK: - UITextViewDelegate

    open func textViewDidBeginEditing(_ textView: UITextView) {
        context.onTextViewEvent(
            .didBeginEditing(
                selectedRange: textView.selectedRange,
                text: textView.attributedText
            )
        )
        context.isEditingText = true
    }

    open func textViewDidChange(_ textView: UITextView) {
        syncWithTextView()
        context.onTextViewEvent(
            .didChange(
                selectedRange: textView.selectedRange,
                text: textView.attributedText
            )
        )
    }

    open func textViewDidChangeSelection(_ textView: UITextView) {
        syncWithTextView()
        context.onTextViewEvent(
            .didChangeSelection(
                selectedRange: textView.selectedRange,
                text: textView.attributedText
            )
        )
    }

    open func textViewDidEndEditing(_ textView: UITextView) {
        syncWithTextView()
        context.onTextViewEvent(
            .didEndEditing(
                selectedRange: textView.selectedRange,
                text: textView.attributedText
            )
        )
        context.isEditingText = false
    }
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

    // MARK: - NSTextViewDelegate

    open func textDidBeginEditing(_ notification: Notification) {
        context.onTextViewEvent(
            .didBeginEditing(
                selectedRange: textView.selectedRange,
                text: textView.attributedString()
            )
        )
        context.isEditingText = true
    }

    open func textDidChange(_ notification: Notification) {
        context.onTextViewEvent(
            .didChange(
                selectedRange: textView.selectedRange,
                text: textView.attributedString()
            )
        )
                syncWithTextView()
    }

    open func textViewDidChangeSelection(_ notification: Notification) {
        replaceCurrentAttributesIfNeeded()
        context.onTextViewEvent(
            .didChangeSelection(
                selectedRange: textView.selectedRange,
                text: textView.attributedString()
            )
        )
                syncWithTextView()
    }

    open func textDidEndEditing(_ notification: Notification) {
        context.onTextViewEvent(
            .didEndEditing(
                selectedRange: textView.selectedRange,
                text: textView.attributedString()
            )
        )
        context.isEditingText = false
    }
#endif
}

#if iOS || os(tvOS) || os(visionOS)
import UIKit

extension RichTextCoordinator: UITextViewDelegate {}

#elseif macOS
import AppKit

extension RichTextCoordinator: NSTextViewDelegate {}
#endif

// MARK: - Public Extensions

public extension RichTextCoordinator {

    /// Reset appearance for the currently highlighted range.
    func resetHighlightedRangeAppearance() {
        guard
            let range = context.highlightedRange,
            let background = highlightedRangeOriginalBackgroundColor,
            let foreground = highlightedRangeOriginalForegroundColor
        else { return }
        textView.setRichTextColor(.background, to: background, at: range)
        textView.setRichTextColor(.foreground, to: foreground, at: range)
    }
}


// MARK: - Internal Extensions

extension RichTextCoordinator {

    /// Sync state from the text view's current state.
    func syncWithTextView() {
        syncContextWithTextView()
        syncTextWithTextView()
    }

    /// Sync the rich text context with the text view.
    func syncContextWithTextView() {
        if shouldDelaySyncContextWithTextView {
            DispatchQueue.main.async {
                self.syncContextWithTextViewAfterDelay()
            }
        } else {
            syncContextWithTextViewAfterDelay()
        }
    }

    func sync<T: Equatable>(_ prop: inout T, with value: T) {
        if prop == value { return }
        prop = value
    }

    /// Sync the rich text context with the text view.
    func syncContextWithTextViewAfterDelay() {
        let font = textView.richTextFont ?? .standardRichTextFont
        sync(&context.attributedString, with: textView.attributedString)
        sync(&context.selectedRange, with: textView.selectedRange)
        sync(&context.canCopy, with: textView.hasSelectedRange)
        sync(&context.canRedoLatestChange, with: textView.undoManager?.canRedo ?? false)
        sync(&context.canUndoLatestChange, with: textView.undoManager?.canUndo ?? false)
        sync(&context.fontName, with: font.fontName)
        sync(&context.fontSize, with: font.pointSize)
        sync(&context.isEditingText, with: textView.isFirstResponder)

        let styles = textView.richTextStyles
        RichTextStyle.allCases.forEach {
            let style = styles.hasStyle($0)
            context.setStyleInternal($0, to: style)
        }

        updateTextViewAttributesIfNeeded()
    }

    /// Sync the text binding with the text view.
    func syncTextWithTextView() {
        DispatchQueue.main.async {
            self.text.wrappedValue = self.textView.attributedString
        }
    }

    /**
     On macOS, we have to update the font and colors when we
     move the text input cursor and there's no selected text.

     The code looks very strange, but setting current values
     to the current values will reset the text view in a way
     that is otherwise not done correctly.

     To try out the incorrect behavior, comment out the code
     below, then change font size, colors etc. for a part of
     the text then move the input cursor around. When you do,
     the presented information will be correct, but when you
     type, the last selected font, colors etc. will be used.
     */
    func updateTextViewAttributesIfNeeded() {
#if macOS
        if textView.hasSelectedRange { return }
        let attributes = textView.richTextAttributes
        textView.setRichTextAttributes(attributes)
#endif
    }

    /**
     On macOS, we have to update the typingAttributes when we
     move the text input cursor and there's no selected text.
     So that the current attributes will set again for updated location.
     */
    func replaceCurrentAttributesIfNeeded() {
#if macOS
        if textView.hasSelectedRange { return }
        let attributes = textView.richTextAttributes
        textView.setNewRichTextAttributes(attributes)
#endif
    }
}
#endif
