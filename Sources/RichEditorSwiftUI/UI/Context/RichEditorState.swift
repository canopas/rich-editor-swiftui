//
//  RichEditorState.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import Combine
import SwiftUI

/// This observable context can be used to affect and observe a
/// ``RichTextEditor`` and its native text view.
///
/// Use ``handle(_:)`` to trigger actions, e.g. to change fonts,
/// text styles, text alignments, select a text range, etc.
///
/// You can use ``RichEditorState/FocusedValueKey`` to handle a
/// context with focus in a multi-windowed app.
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

  @Published
  public var headerType: HeaderType = .default

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
  public internal(set) var highlightingStyle = RichTextHighlightingStyle
    .standard

  /// The current paragraph style.
  @Published
  public internal(set) var paragraphStyle = NSParagraphStyle.default

  /// The current rich text styles.
  @Published
  public internal(set) var styles = [RichTextStyle: Bool]()

  @Published
  public internal(set) var link: String? = nil

  // MARK: - Properties

  /// This publisher can emit actions to the coordinator.
  public let actionPublisher = RichTextAction.Publisher()

  /// The currently highlighted range, if any.
  public var highlightedRange: NSRange?

  //MARK: - Variables To Handle JSON
  internal var adapter: EditorAdapter = DefaultAdapter()

  @Published internal var activeStyles: Set<RichTextSpanStyle> = []
  @Published internal var activeAttributes: [NSAttributedString.Key: Any]? =
    [:]

  internal var internalSpans: [RichTextSpanInternal] = []

  internal var rawText: String = ""

  internal var updateAttributesQueue: [(span: RichTextSpanInternal, shouldApply: Bool)] = []
  #if os(iOS) || os(tvOS) || os(macOS) || os(visionOS)
    internal let alertController: RichTextAlertController = RichTextAlertController()
  #endif

  /**
     This will provide encoded text which is of type RichText
     */
  public var richText: RichText {
    return getRichText()
  }

  internal var spans: RichTextSpans {
    return internalSpans.map({
      .init(
        insert: getStringWith(from: $0.from, to: $0.to),
        attributes: $0.attributes)
    })
  }

  var internalRichText: RichText = .init()
  //MARK: - Initializers
  /**
     Init with richText which is of type RichText
     */
  public init(richText: RichText) {
    internalRichText = richText
    let input = richText.spans.map({ $0.insert }).joined()
    var tempSpans: [RichTextSpanInternal] = []
    var text = ""
    richText.spans.forEach({
      let span = RichTextSpanInternal(
        from: text.utf16Length,
        to: (text.utf16Length + $0.insert.utf16Length - 1),
        attributes: $0.attributes)
      tempSpans.append(span)
      text += $0.insert
    })

    let str = NSMutableAttributedString(string: text)

    tempSpans.forEach { span in
      str.addAttributes(
        span.attributes?.toAttributes(font: .standardRichTextFont)
          ?? [:], range: span.spanRange)
      if span.attributes?.color == nil {
        var color: ColorRepresentable = .clear
        #if os(watchOS)
          color = .black
        #else
          color = RichTextView.Theme.standard.fontColor
        #endif
        str.addAttributes(
          [.foregroundColor: color], range: span.spanRange)
      }
    }

    self.attributedString = str

    self.internalSpans = tempSpans

    selectedRange = NSRange(location: 0, length: 0)
    activeStyles = []

    rawText = input
  }

  /**
     Init with input which is of type String
     */
  public init(input: String) {
    let adapter = DefaultAdapter()

    self.adapter = adapter

    let str = NSMutableAttributedString(string: input)

    str.addAttributes(
      [.font: FontRepresentable.standardRichTextFont],
      range: str.richTextRange)
    self.attributedString = str

    self.internalSpans = [
      .init(
        from: 0, to: input.utf16Length > 0 ? input.utf16Length - 1 : 0,
        attributes: RichAttributes())
    ]

    selectedRange = NSRange(location: 0, length: 0)
    activeStyles = []

    rawText = input
  }
}

extension RichEditorState {

  /// Whether or not the context has a selected range.
  public var hasHighlightedRange: Bool {
    highlightedRange != nil
  }

  /// Whether or not the context has a selected range.
  public var hasSelectedRange: Bool {
    selectedRange.length > 0
  }
}

extension RichEditorState {

  /// Set ``highlightedRange`` to a new, optional range.
  public func highlightRange(_ range: NSRange?) {
    actionPublisher.send(.setHighlightedRange(range))
    highlightedRange = range
  }

  /// Reset the attributed string.
  public func resetAttributedString() {
    setAttributedString(to: "")
  }

  /// Reset the ``highlightedRange``.
  public func resetHighlightedRange() {
    guard hasHighlightedRange else { return }
    highlightedRange = nil
  }

  /// Reset the ``selectedRange``.
  public func resetSelectedRange() {
    selectedRange = NSRange()
  }

  /// Set a new range and start editing.
  public func selectRange(_ range: NSRange) {
    isEditingText = true
    actionPublisher.send(.selectRange(range))
  }

  /// Set the attributed string to a new plain text.
  public func setAttributedString(to text: String) {
    setAttributedString(to: NSAttributedString(string: text))
  }

  /// Set the attributed string to a new rich text.
  public func setAttributedString(to string: NSAttributedString) {
    let mutable = NSMutableAttributedString(attributedString: string)
    actionPublisher.send(.setAttributedString(mutable))
  }

  /// Set ``isEditingText`` to `false`.
  public func stopEditingText() {
    isEditingText = false
  }

  /// Toggle whether or not the text is being edited.
  public func toggleIsEditing() {
    isEditingText.toggle()
  }
}
