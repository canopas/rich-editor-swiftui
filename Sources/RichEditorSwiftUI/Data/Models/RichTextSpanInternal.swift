//
//  RichTextSpanInternal.swift
//
//
//  Created by Divyesh Vekariya on 12/10/23.
//

import Foundation

public struct RichTextSpanInternal {
    public let id: String
    public let from: Int
    public let to: Int
    //    public let insert: String
    public let attributes: RichAttributes?

    public init(id: String = UUID().uuidString,
                from: Int,
                to: Int,
                //                insert: String,
                attributes: RichAttributes? = RichAttributes()) {
        self.id = id
        self.from = from
        self.to = to
        //        self.insert = insert
        self.attributes = attributes
    }
}

extension RichTextSpanInternal: Equatable {
    public static func == (lhs: RichTextSpanInternal,
                           rhs: RichTextSpanInternal) -> Bool {
        return lhs.from == rhs.from
        && lhs.to == rhs.to
        //        && lhs.insert == rhs.insert
        && lhs.attributes == rhs.attributes
    }
}

extension RichTextSpanInternal: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
        //        hasher.combine(insert)
        hasher.combine(attributes)
    }
}

extension RichTextSpanInternal {
    public var spanRange: NSRange {
        let range = NSRange(location: from, length: max(((to - from) + 1), 0))
        return range
    }

    public var closedRange: ClosedRange<Int> {
        return from...to
    }

    public var length: Int {
        return to - from
    }
}

extension RichTextSpanInternal {
    public func copy(from: Int? = nil,
                     to: Int? = nil,
                     //                     insert: String? = nil,
                     attributes: RichAttributes? = nil) -> RichTextSpanInternal {
        return RichTextSpanInternal(
            from: (from != nil ? from! : self.from),
            to: (to != nil ? to! : self.to),
            //            insert: (insert != nil ? insert! : self.insert),
            attributes: (attributes != nil ? attributes! : self.attributes)
        )
    }
}
