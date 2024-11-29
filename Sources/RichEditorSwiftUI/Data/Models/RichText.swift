//
//  RichText.swift
//
//
//  Created by Divyesh Vekariya on 12/02/24.
//

import Foundation

typealias RichTextSpans = [RichTextSpan]

public struct RichText: Codable {
    public let spans: [RichTextSpan]

    public init(spans: [RichTextSpan] = []) {
        self.spans = spans
    }

    func encodeToData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

public struct RichTextSpan: Codable {
    //    public var id: String = UUID().uuidString
    public let insert: String
    public let attributes: RichAttributes?

    public init(insert: String,
                attributes: RichAttributes? = nil) {
        //        self.id = id
        self.insert = insert
        self.attributes = attributes
    }
}

