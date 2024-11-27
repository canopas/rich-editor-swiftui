//
//  RichTextDataReader.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import Foundation

/**
 This protocol extends ``RichTextReader`` with functionality
 for reading rich text data for the current rich text.

 The protocol is implemented by `NSAttributedString` as well
 as other types in the library.
 */
public protocol RichTextDataReader: RichTextReader {}

extension NSAttributedString: RichTextDataReader {}

public extension RichTextDataReader {

    /**
     Generate rich text data from the current rich text.

     - Parameters:
       - format: The data format to use.
     */
    func richTextData(
        for format: RichTextDataFormat
    ) throws -> Data {
        switch format {
        case .archivedData: try richTextArchivedData()
        case .plainText: try richTextPlainTextData()
        case .rtf: try richTextRtfData()
        case .vendorArchivedData: try richTextArchivedData()
        }
    }
}

private extension RichTextDataReader {

    /// The full text range.
    var textRange: NSRange {
        NSRange(location: 0, length: richText.length)
    }

    /// The full text range.
    func documentAttributes(
        for documentType: NSAttributedString.DocumentType
    ) -> [NSAttributedString.DocumentAttributeKey: Any] {
        [.documentType: documentType]
    }

    /// Generate archived formatted data.
    func richTextArchivedData() throws -> Data {
        try NSKeyedArchiver.archivedData(
            withRootObject: richText,
            requiringSecureCoding: false
        )
    }

    /// Generate plain text formatted data.
    func richTextPlainTextData() throws -> Data {
        let string = richText.string
        guard let data = string.data(using: .utf8) else {
            throw RichTextDataError
                .invalidData(in: string)
        }
        return data
    }

    /// Generate RTF formatted data.
    func richTextRtfData() throws -> Data {
        try richText.data(
            from: textRange,
            documentAttributes: documentAttributes(for: .rtf)
        )
    }

    /// Generate RTFD formatted data.
    func richTextRtfdData() throws -> Data {
        try richText.data(
            from: textRange,
            documentAttributes: documentAttributes(for: .rtfd)
        )
    }

    #if macOS
    /// Generate Word formatted data.
    func richTextWordData() throws -> Data {
        try richText.data(
            from: textRange,
            documentAttributes: documentAttributes(for: .docFormat)
        )
    }
    #endif
}
