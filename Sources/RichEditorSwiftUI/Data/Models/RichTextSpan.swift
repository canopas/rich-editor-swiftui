//
//  RichTextSpan.swift
//
//
//  Created by Divyesh Vekariya on 12/10/23.
//

import Foundation

public class RichTextSpan: Codable {
    public let id: String
    public let from: Int
    public var to: Int
    public let style: TextSpanStyle
    
    public init(from: Int, to: Int, style: TextSpanStyle) {
        self.id = UUID().uuidString
        self.from = from
        self.to = to
        self.style = style
    }
}

extension RichTextSpan {
    public func update(to: Int) {
        self.to = to
    }
}

extension RichTextSpan: Equatable {
    public static func == (lhs: RichTextSpan, rhs: RichTextSpan) -> Bool {
        return lhs.id == rhs.id && lhs.from == rhs.from && lhs.to == rhs.to && lhs.style == rhs.style
    }
}

extension RichTextSpan: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
