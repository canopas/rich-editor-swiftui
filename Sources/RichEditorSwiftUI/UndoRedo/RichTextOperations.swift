//
//  RichTextOperations.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 03/01/25.
//

import Foundation
import SwiftUI

struct RichTextOperation {
  let operationType: OperationType
  let range: NSRange
  let attributes: OperationAttributes
  let previousAttributes: OperationAttributes
  init(
    operationType: OperationType, range: NSRange, attributes: OperationAttributes,
    previousAttributes: OperationAttributes
  ) {
    self.operationType = operationType
    self.range = range
    self.attributes = attributes
    self.previousAttributes = previousAttributes
  }
}

enum OperationType {
  case addOrRemoveText
  case addOrRemoveStyle(style: RichTextSpanStyle, isAdded: Bool)
  case setStyleStyle(previousStyle: RichTextSpanStyle?, newStyle: RichTextSpanStyle, isSet: Bool)
}

struct OperationAttributes {
  let attributedString: NSAttributedString
  let selectedRange: NSRange
  let headerType: HeaderType
  let textAlignment: RichTextAlignment
  let fontName: String
  let fontSize: CGFloat
  let lineSpacing: CGFloat
  let colors: [RichTextColor: ColorRepresentable]
  let highlightingStyle: RichTextHighlightingStyle
  let paragraphStyle: NSParagraphStyle
  let styles: [RichTextStyle: Bool]
  let link: String?
  let highlightedRange: NSRange?
  let activeStyles: Set<RichTextSpanStyle>
  let activeAttributes: [NSAttributedString.Key: Any]?
  let rawText: String

  init(
    attributedString: NSAttributedString,
    selectedRange: NSRange,
    headerType: HeaderType,
    textAlignment: RichTextAlignment,
    fontName: String,
    fontSize: CGFloat,
    lineSpacing: CGFloat,
    colors: [RichTextColor: ColorRepresentable],
    highlightingStyle: RichTextHighlightingStyle,
    paragraphStyle: NSParagraphStyle,
    styles: [RichTextStyle: Bool],
    link: String?,
    highlightedRange: NSRange?,
    activeStyles: Set<RichTextSpanStyle>,
    activeAttributes: [NSAttributedString.Key: Any]?,
    rawText: String
  ) {
    self.attributedString = attributedString
    self.selectedRange = selectedRange
    self.headerType = headerType
    self.textAlignment = textAlignment
    self.fontName = fontName
    self.fontSize = fontSize
    self.lineSpacing = lineSpacing
    self.colors = colors
    self.highlightingStyle = highlightingStyle
    self.paragraphStyle = paragraphStyle
    self.styles = styles
    self.link = link
    self.highlightedRange = highlightedRange
    self.activeStyles = activeStyles
    self.activeAttributes = activeAttributes
    self.rawText = rawText
  }
}
