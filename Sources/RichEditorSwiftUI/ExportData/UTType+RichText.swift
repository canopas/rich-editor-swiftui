//
//  UTType+RichText.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import UniformTypeIdentifiers

extension UTType {

  /// Uniform rich text types that RichTextEditor supports.
  public static let richTextTypes: [UTType] = [
    .archivedData,
    .rtf,
    .text,
    .plainText,
    .data,
  ]

  /// The uniform type for ``RichTextDataFormat/archivedData``.
  public static let archivedData = UTType(
    exportedAs: "com.richtexteditor.archiveddata")
}

extension Collection where Element == UTType {

  /// The uniforum types that rich text documents support.
  public static var richTextTypes: [UTType] { UTType.richTextTypes }
}
