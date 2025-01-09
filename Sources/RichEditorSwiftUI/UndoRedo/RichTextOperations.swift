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
  init(operationType: OperationType, range: NSRange, attributes: OperationAttributes) {
    self.operationType = operationType
    self.range = range
    self.attributes = attributes
  }
}

enum OperationType {
  case addOrRemoveText(newText: NSAttributedString, rawText: String, isAdded: Bool)
  case addOrRemoveStyle(style: RichTextSpanStyle, isAdded: Bool)
  case setStyleStyle(previousStyle: RichTextSpanStyle?, newStyle: RichTextSpanStyle, isSet: Bool)
}

struct OperationAttributes {
  let activeStyles: Set<RichTextSpanStyle>
  let headerType: HeaderType
  let textAlignment: RichTextAlignment
  let fontName: String
  let fontSize: CGFloat
  let colors: [RichTextColor: ColorRepresentable]
  let lineSpacing: CGFloat
  let paragraphStyle: NSParagraphStyle
  let styles: [RichTextStyle: Bool]
  let link: String?

  init(
    activeStyles: Set<RichTextSpanStyle>,
    headerType: HeaderType,
    textAlignment: RichTextAlignment,
    fontName: String,
    fontSize: CGFloat,
    colors: [RichTextColor: ColorRepresentable],
    lineSpacing: CGFloat,
    paragraphStyle: NSParagraphStyle,
    styles: [RichTextStyle: Bool],
    link: String?
  ) {
    self.activeStyles = activeStyles
    self.headerType = headerType
    self.textAlignment = textAlignment
    self.fontName = fontName
    self.fontSize = fontSize
    self.colors = colors
    self.lineSpacing = lineSpacing
    self.paragraphStyle = paragraphStyle
    self.styles = styles
    self.link = link
  }
}
