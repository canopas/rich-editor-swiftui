//
//  RichTextViewComponent+Pasting.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import Foundation

#if canImport(UIKit)
  import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
  import AppKit
#endif

extension RichTextViewComponent {

  /**
     Paste an image into the rich text, at a certain index.

     Pasting images only works on iOS, tvOS and macOS. Other
     platform will trigger an assertion failure.

     > Todo: This automatically inserts images as compressed
     jpeg. We should make it more configurable.

     - Parameters:
     - image: The image to paste.
     - index: The index to paste at.
     - moveCursorToPastedContent: Whether or not the input
     cursor should be moved to the end of the pasted content,
     by default `false`.
     */
  public func pasteImage(
    _ image: ImageRepresentable,
    at index: Int,
    moveCursorToPastedContent: Bool = true
  ) -> NSMutableAttributedString? {
    return pasteImages(
      [image],
      at: index,
      moveCursorToPastedContent: moveCursorToPastedContent
    )
  }

  /**
     Paste images into the text view, at a certain index.

     This will automatically insert an image as a compressed
     jpeg. We should make it more configurable.

     > Todo: This automatically inserts images as compressed
     jpeg. We should make it more configurable.

     - Parameters:
     - images: The images to paste.
     - index: The index to paste at.
     - moveCursorToPastedContent: Whether or not the input
     cursor should be moved to the end of the pasted content,
     by default `false`.
     */
  public func pasteImages(
    _ images: [ImageRepresentable],
    at index: Int,
    moveCursorToPastedContent move: Bool = false
  ) -> NSMutableAttributedString? {
    #if os(watchOS)
      assertionFailure("Image pasting is not supported on this platform")
    #else
      guard validateImageInsertion(for: imagePasteConfiguration) else { return nil }
      let items = images.count * 2  // The number of inserted "items" is the images and a newline for each
      let insertRange = NSRange(location: index, length: 0)
      let safeInsertRange = safeRange(for: insertRange)
      let isSelectedRange = (index == selectedRange.location)
      if isSelectedRange { deleteCharacters(in: selectedRange) }
      if move { moveInputCursor(to: index) }
      let insertedString: NSMutableAttributedString = .init()
      images.reversed().forEach {
        insertedString.append(performPasteImage($0, at: index) ?? .init())
      }
      if move { moveInputCursor(to: safeInsertRange.location + items) }
      if move || isSelectedRange {
        self.moveInputCursor(to: self.selectedRange.location)
      }
      return insertedString
    #endif
  }

  public func setImageAttachment(imageAttachment: ImageAttachment) {
    guard let range = imageAttachment.range else { return }
    let image = imageAttachment.image
    performSetImageAttachment(image, at: range)
  }

  /**
     Paste text into the text view, at a certain index.

     - Parameters:
     - text: The text to paste.
     - index: The text index to paste at.
     - moveCursorToPastedContent: Whether or not the input
     cursor should be moved to the end of the pasted content,
     by default `false`.
     */
  public func pasteText(
    _ text: String,
    at index: Int,
    moveCursorToPastedContent: Bool = false
  ) {
    let selected = selectedRange
    let isSelectedRange = (index == selected.location)
    let content = NSMutableAttributedString(attributedString: richText)
    let insertString = NSMutableAttributedString(string: text)
    let insertRange = NSRange(location: index, length: 0)
    let safeInsertRange = safeRange(for: insertRange)
    let safeMoveIndex = safeInsertRange.location + insertString.length
    let attributes = content.richTextAttributes(at: safeInsertRange)
    let attributeRange = NSRange(location: 0, length: insertString.length)
    let safeAttributeRange = safeRange(for: attributeRange)
    insertString.setRichTextAttributes(attributes, at: safeAttributeRange)
    content.insert(insertString, at: index)
    setRichText(content)
    if moveCursorToPastedContent {
      moveInputCursor(to: safeMoveIndex)
    } else if isSelectedRange {
      moveInputCursor(to: selected.location + text.count)
    }
  }
}

#if iOS || macOS || os(tvOS) || os(visionOS)
  extension RichTextViewComponent {

    fileprivate func getAttachmentString(
      for image: ImageRepresentable
    ) -> NSMutableAttributedString? {
      guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
      guard let compressed = ImageRepresentable(data: data) else { return nil }
      let attachment = RichTextImageAttachment(jpegData: data)
      attachment.bounds = attachmentBounds(for: compressed)
      return NSMutableAttributedString(attachment: attachment)
    }

    fileprivate func performPasteImage(
      _ image: ImageRepresentable,
      at index: Int
    ) -> NSMutableAttributedString? {
      let newLine = NSAttributedString(string: "\n", attributes: richTextAttributes)
      let content = NSMutableAttributedString(attributedString: richText)
      guard let insertString = getAttachmentString(for: image) else { return nil }

      insertString.insert(newLine, at: insertString.length)
      insertString.addAttributes(richTextAttributes, range: insertString.richTextRange)
      content.insert(insertString, at: index)

      setRichText(content)
      return insertString
    }
  }
#endif

#if iOS || macOS || os(tvOS) || os(visionOS)
  extension RichTextViewComponent {
    fileprivate func performSetImageAttachment(
      _ image: ImageRepresentable,
      at range: NSRange
    ) {
      guard let attachmentString = getAttachmentString(for: image) else { return }
      mutableAttributedString?.replaceCharacters(in: range, with: attachmentString)
    }
  }
#endif
