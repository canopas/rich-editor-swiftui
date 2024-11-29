//
//  NSAttributedString+Init.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import Foundation

public extension NSAttributedString {

    /**
     Try to parse ``RichTextDataFormat`` formatted data.

     - Parameters:
       - data: The data to initialize the string with.
       - format: The data format to use.
     */
    convenience init(
        data: Data,
        format: RichTextDataFormat
    ) throws {
        switch format {
        case .archivedData: try self.init(archivedData: data)
        case .plainText: try self.init(plainTextData: data)
        case .rtf: try self.init(rtfData: data)
        case .vendorArchivedData: try self.init(archivedData: data)
        }
    }
}

private extension NSAttributedString {

    /// Try to parse ``RichTextDataFormat/archivedData``.
    convenience init(archivedData data: Data) throws {
        let unarchived = try NSKeyedUnarchiver.unarchivedObject(
            ofClass: NSAttributedString.self,
            from: data)
        guard let string = unarchived else {
            throw RichTextDataError.invalidArchivedData(in: data)
        }
        self.init(attributedString: string)
    }

    /// Try to parse ``RichTextDataFormat/plainText`` data.
    convenience init(plainTextData data: Data) throws {
        let decoded = String(data: data, encoding: .utf8)
        guard let string = decoded else {
            throw RichTextDataError.invalidPlainTextData(in: data)
        }
        let attributed = NSAttributedString(string: string)
        self.init(attributedString: attributed)
    }

    /// Try to parse ``RichTextDataFormat/rtf`` data.
    convenience init(rtfData data: Data) throws {
        var attributes = Self.rtfDataAttributes as NSDictionary?
        try self.init(
            data: data,
            options: [.characterEncoding: Self.utf8],
            documentAttributes: &attributes
        )
    }

    /// Try to parse ``RichTextDataFormat/rtfd`` data.
    convenience init(rtfdData data: Data) throws {
        var attributes = Self.rtfdDataAttributes as NSDictionary?
        try self.init(
            data: data,
            options: [.characterEncoding: Self.utf8],
            documentAttributes: &attributes
        )
    }

    #if macOS
    /// Try to parse ``RichTextDataFormat/word`` data.
    convenience init(wordData data: Data) throws {
        var attributes = Self.wordDataAttributes as NSDictionary?
        try self.init(
            data: data,
            options: [.characterEncoding: Self.utf8],
            documentAttributes: &attributes
        )
    }
    #endif

    convenience init(jsonData data: Data) throws {
        let decoder = JSONDecoder()
        let richText = try? decoder.decode(RichText.self, from: data)
        guard let richText = richText else {
            throw RichTextDataError.invalidPlainTextData(in: data)
        }

        var tempSpans: [RichTextSpanInternal] = []
        var text = ""
        richText.spans.forEach({
            let span = RichTextSpanInternal(from: text.utf16Length,
                                            to: (text.utf16Length + $0.insert.utf16Length - 1),
                                            attributes: $0.attributes)
            tempSpans.append(span)
            text += $0.insert
        })

        let attributedString = NSMutableAttributedString(string: text)

        tempSpans.forEach { span in
            attributedString.addAttributes(span.attributes?.toAttributes() ?? [:], range: span.spanRange)
        }
        self.init(attributedString: attributedString)
    }
}

private extension NSAttributedString {

    static var utf8: UInt {
        String.Encoding.utf8.rawValue
    }

    static var rtfDataAttributes: [DocumentAttributeKey: Any] {
        [.documentType: NSAttributedString.DocumentType.rtf]
    }

    static var rtfdDataAttributes: [DocumentAttributeKey: Any] {
        [.documentType: NSAttributedString.DocumentType.rtfd]
    }

    #if macOS
    static var wordDataAttributes: [DocumentAttributeKey: Any] {
        [.documentType: NSAttributedString.DocumentType.docFormat]
    }
    #endif
}
