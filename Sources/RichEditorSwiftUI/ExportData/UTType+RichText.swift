//
//  UTType+RichText.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import UniformTypeIdentifiers

public extension UTType {

    /// Uniform rich text types that RichTextKit supports.
    static let richTextTypes: [UTType] = [
        .archivedData,
        .rtf,
        .text,
        .plainText,
        .data
    ]

    /// The uniform type for ``RichTextDataFormat/archivedData``.
    static let archivedData = UTType(
        exportedAs: "com.richtextkit.archiveddata")
}

public extension Collection where Element == UTType {

    /// The uniforum types that rich text documents support.
    static var richTextTypes: [UTType] { UTType.richTextTypes }
}
