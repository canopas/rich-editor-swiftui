//
//  RichEditorState.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import SwiftUI
import Combine

/**
 This observable context can be used to affect and observe a
 ``RichTextEditor`` and its native text view.

 Use ``handle(_:)`` to trigger actions, e.g. to change fonts,
 text styles, text alignments, select a text range, etc.

 You can use ``RichEditorState/FocusedValueKey`` to handle a
 context with focus in a multi-windowed app.
 */
public class RichEditorState: ObservableObject {

    /// Create a new rich text context instance.
    public init() {}

    // MARK: - Not yet observable properties

    /**
     The currently attributed string, if any.

     Note that the property is read-only and not `@Published`
     to avoid redrawing the editor when it changes, which is
     done as the user types. We should find a way to observe
     it without this happening. The best way to observe this
     property is to use the raw `text` binding that you pass
     into the text editor. The editor will not redraw if you
     change this value from the outside.

     Until then, use `setAttributedString(to:)` to change it.
     */
    public internal(set) var attributedString = NSAttributedString()

    /// The currently selected range, if any.
    public internal(set) var selectedRange = NSRange()

    // MARK: - Bindable & Settable Properies

    /// Whether or not the rich text editor is editable.
    @Published
    public var isEditable = true

    /// Whether or not the text is currently being edited.
    @Published
    public var isEditingText = false

    /// The current text alignment, if any.
    @Published
    public var textAlignment: RichTextAlignment = .left

    /// The current font name.
    @Published
    public var fontName = RichTextFont.PickerFont.all.first?.fontName ?? ""

    /// The current font size.
    @Published
    public var fontSize = CGFloat.standardRichTextFontSize

    /// The current line spacing.
    @Published
    public var lineSpacing: CGFloat = 10.0

    // MARK: - Observable Properties

    /// Whether or not the current rich text can be copied.
    @Published
    public internal(set) var canCopy = false

    /// Whether or not the latest undo can be redone.
    @Published
    public internal(set) var canRedoLatestChange = false

    /// Whether or not the latest change can be undone.
    @Published
    public internal(set) var canUndoLatestChange = false

    /// The current color values.
    @Published
    public internal(set) var colors = [RichTextColor: ColorRepresentable]()

    /// The style to apply when highlighting a range.
    @Published
    public internal(set) var highlightingStyle = RichTextHighlightingStyle.standard

    /// The current paragraph style.
    @Published
    public internal(set) var paragraphStyle = NSParagraphStyle.default

    /// The current rich text styles.
    @Published
    public internal(set) var styles = [RichTextStyle: Bool]()

    // MARK: - Properties

    /// This publisher can emit actions to the coordinator.
    public let actionPublisher = RichTextAction.Publisher()

    /// The currently highlighted range, if any.
    public var highlightedRange: NSRange?

    ///The currentFont provide current font
//    internal var currentFont: FontRepresentable {
//        return .init(name: fontName, size: fontSize) ?? .standardRichTextFont
//    }

//MARK: - Variables To Handle JSON
    internal var adapter: EditorAdapter = DefaultAdapter()

//    @Published internal var attributedString: NSMutableAttributedString
    @Published internal var activeStyles: Set<TextSpanStyle> = []
    @Published internal var activeAttributes: [NSAttributedString.Key: Any]? = [:]
    internal var currentFont: FontRepresentable = .systemFont(ofSize: .standardRichTextFontSize)

    @Published internal var attributesToApply: ((spans: [(span: RichTextSpanInternal, shouldApply: Bool)], onCompletion: () -> Void))? = nil

    //    private var internalSpans: [RichTextSpan] = []

    internal var internalSpans: [RichTextSpanInternal] = []

    internal var rawText: String = ""

    internal var updateAttributesQueue: [(span: RichTextSpanInternal, shouldApply: Bool)] = []

    /**
     This will provide encoded text which is of type RichText
     */
    public var richText: RichText {
        return getRichText()
    }

    internal var spans: RichTextSpans {
        return internalSpans.map({ .init(insert: getStringWith(from: $0.from, to: $0.to), attributes: $0.attributes) })
    }

    //MARK: - Initializers
    /**
     Init with richText which is of type RichText
     */
    public init(richText: RichText) {
        let input = richText.spans.map({ $0.insert }).joined()

//        self.attributedString = NSAttributedString(string: input)
        var tempSpans: [RichTextSpanInternal] = []
        var text = ""
        richText.spans.forEach({
            let span = RichTextSpanInternal(from: text.utf16Length,
                                            to: (text.utf16Length + $0.insert.utf16Length - 1),
                                            attributes: $0.attributes)
            tempSpans.append(span)
            text += $0.insert
        })

        let str = NSMutableAttributedString(string: text)

        tempSpans.forEach { span in
            str.addAttributes(span.attributes?.toAttributes() ?? [:], range: span.spanRange)
        }

        self.attributedString = str

        self.internalSpans = tempSpans

        selectedRange = NSRange(location: 0, length: 0)
        activeStyles = []

        rawText = input
        setUpSpans()
    }

    /**
     Init with input which is of type String
     */
    public init(input: String) {
        let adapter = DefaultAdapter()

        self.adapter = adapter

        let str = NSMutableAttributedString(string: input)

        str.addAttributes([.font: currentFont], range: str.richTextRange)
        self.attributedString = str

        self.internalSpans = [.init(from: 0, to: input.utf16Length > 0 ? input.utf16Length - 1 : 0, attributes: RichAttributes())]

        selectedRange = NSRange(location: 0, length: 0)
        activeStyles = []

        rawText = input
        setUpSpans()
    }

}

public extension RichEditorState {

    /// Whether or not the context has a selected range.
    var hasHighlightedRange: Bool {
        highlightedRange != nil
    }

    /// Whether or not the context has a selected range.
    var hasSelectedRange: Bool {
        selectedRange.length > 0
    }
}

public extension RichEditorState {

    /// Set ``highlightedRange`` to a new, optional range.
    func highlightRange(_ range: NSRange?) {
        actionPublisher.send(.setHighlightedRange(range))
        highlightedRange = range
    }

    /// Reset the attributed string.
    func resetAttributedString() {
        setAttributedString(to: "")
    }

    /// Reset the ``highlightedRange``.
    func resetHighlightedRange() {
        guard hasHighlightedRange else { return }
        highlightedRange = nil
    }

    /// Reset the ``selectedRange``.
    func resetSelectedRange() {
        selectedRange = NSRange()
    }

    /// Set a new range and start editing.
    func selectRange(_ range: NSRange) {
        isEditingText = true
        actionPublisher.send(.selectRange(range))
    }

    /// Set the attributed string to a new plain text.
    func setAttributedString(to text: String) {
        setAttributedString(to: NSAttributedString(string: text))
    }

    /// Set the attributed string to a new rich text.
    func setAttributedString(to string: NSAttributedString) {
        let mutable = NSMutableAttributedString(attributedString: string)
        actionPublisher.send(.setAttributedString(mutable))
    }

    /// Set ``isEditingText`` to `false`.
    func stopEditingText() {
        isEditingText = false
    }

    /// Toggle whether or not the text is being edited.
    func toggleIsEditing() {
        isEditingText.toggle()
    }
}

