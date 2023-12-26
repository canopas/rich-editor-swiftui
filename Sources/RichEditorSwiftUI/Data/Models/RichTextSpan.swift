//
//  RichTextSpan.swift
//
//
//  Created by Divyesh Vekariya on 12/10/23.
//

import Foundation

public struct RichTextSpan: Codable {
    public let from: Int
    public let to: Int
    public let style: TextSpanStyle
    
    public init(from: Int, to: Int, style: TextSpanStyle) {
        self.from = from
        self.to = to
        self.style = style
    }
}

extension RichTextSpan: Equatable {
    public static func == (lhs: RichTextSpan, rhs: RichTextSpan) -> Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to && lhs.style == rhs.style
    }
}

extension RichTextSpan: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
        hasher.combine(style)
    }
}
