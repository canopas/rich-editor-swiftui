//
//  RichEditor.swift
//
//
//  Created by Divyesh Vekariya on 24/10/23.
//


#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI
import Combine

/**
 This view can be used to view and edit rich text in SwiftUI.

 The view uses a platform-specific ``RichTextView`` together
 with a ``RichEditorState`` and a ``RichTextCoordinator`` to
 keep the view and context in sync.

 You can use the provided context to trigger and observe any
 changes to the text editor. Note that changing the value of
 the `text` binding will not yet update the editor. Until it
 is fixed, use `setAttributedString(to:)`.

 Since the view wraps a native `UIKit` or `AppKit` text view,
 you can't apply `.toolbar` modifiers to it, like you can do
 with other SwiftUI views. This means that this doesn't work:

 ```swift
 RichTextEditor(text: $text, context: context)
 .toolbar {
 ToolbarItemGroup(placement: .keyboard) {
 ....
 }
 }
 ```

 This will not show anything. To work around this limitation,
 use a ``RichTextKeyboardToolbar`` instead.

 You can configure and style the view by applying its config
 and style view modifiers to your view hierarchy:

 ```swift
 VStack {
 RichTextEditor(...)
 ...
 }
 .richTextEditorStyle(...)
 .richTextEditorConfig(...)
 ```

 For more information, see ``RichTextKeyboardToolbarConfig``
 and ``RichTextKeyboardToolbarStyle``.
 */
public struct RichTextEditor: ViewRepresentable {

    @State var cancellable: Set<AnyCancellable> = []

    /// Create a rich text editor with a rich text value and
    /// a certain rich text data format.
    ///
    /// - Parameters:
    ///   - context: The rich editor state to use.
    ///   - viewConfiguration: A platform-specific view configuration, if any.
    public init(
        context: ObservedObject<RichEditorState>,
        viewConfiguration: @escaping ViewConfiguration = { _ in }
    ) {
        self._context = context
        self.viewConfiguration = viewConfiguration
    }

    public typealias ViewConfiguration = (RichTextViewComponent) -> Void

    @ObservedObject
    private var context: RichEditorState
    
    private var viewConfiguration: ViewConfiguration

    @Environment(\.richTextEditorConfig)
    private var config

    @Environment(\.richTextEditorStyle)
    private var style

#if iOS || os(tvOS) || os(visionOS)
    public let textView = RichTextView()
#endif

#if macOS
    public let scrollView = RichTextView.scrollableTextView()

    public var textView: RichTextView {
        scrollView.documentView as? RichTextView ?? RichTextView()
    }
#endif

    public func makeCoordinator() -> RichTextCoordinator {
        RichTextCoordinator(
            text: $context.attributedString,
            textView: textView,
            richTextContext: context
        )
    }

#if iOS || os(tvOS) || os(visionOS)
    public func makeUIView(context: Context) -> some UIView {
        textView.setup()
        textView.configuration = config
        textView.theme = style
        viewConfiguration(textView)
        return textView
    }

    public func updateUIView(_ view: UIViewType, context: Context) {
        if !(self.context.activeAttributes?
            .contains(where: { $0.key == .font }) ?? false) {
            self.textView.typingAttributes = [.font: style.font]
        }
    }

#else

    public func makeNSView(context: Context) -> some NSView {
        if self.context.internalSpans.isEmpty {
            textView.setup()
        } else {
            textView.setup()
        }
        textView.configuration = config
        textView.theme = style
        viewConfiguration(textView)
        return scrollView
    }

    public func updateNSView(_ view: NSViewType, context: Context) {
        
    }
#endif
}

// MARK: RichTextPresenter

public extension RichTextEditor {

    /// Get the currently selected range.
    var selectedRange: NSRange {
        textView.selectedRange
    }
}

// MARK: RichTextReader

public extension RichTextEditor {

    /// Get the string that is managed by the editor.
    var attributedString: NSAttributedString {
        context.attributedString
    }
}

// MARK: RichTextWriter

public extension RichTextEditor {

    /// Get the mutable string that is managed by the editor.
    var mutableAttributedString: NSMutableAttributedString? {
        textView.mutableAttributedString
    }
}
#endif
