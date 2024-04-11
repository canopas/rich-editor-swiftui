//
//  RichAttributes.swift
//
//
//  Created by Divyesh Vekariya on 04/04/24.
//

import Foundation

// MARK: - RichAttributes
public struct RichAttributes: Codable {
    //    public let id: String
    public let bold: Bool?
    public let italic: Bool?
    public let underline: Bool?
    public let header: HeaderType?
    //    public let list: ListType?

    public init(
        //        id: String = UUID().uuidString,
        bold: Bool? = nil,
        italic: Bool? = nil,
        underline: Bool? = nil,
        header: HeaderType? = nil
        //                list: ListType? = nil
    ) {
        //        self.id = id
        self.bold = bold
        self.italic = italic
        self.underline = underline
        self.header = header
        //        self.list = list
    }

    enum CodingKeys: String, CodingKey {
        case bold = "bold"
        case italic = "italic"
        case underline = "underline"
        case header = "header"
        //        case list = "list"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        //        self.id = UUID().uuidString
        self.bold = try values.decodeIfPresent(Bool.self, forKey: .bold)
        self.italic = try values.decodeIfPresent(Bool.self, forKey: .italic)
        self.underline = try values.decodeIfPresent(Bool.self, forKey: .underline)
        self.header = try values.decodeIfPresent(HeaderType.self, forKey: .header)
        //        self.list = try values.decodeIfPresent(ListType.self, forKey: .list)
    }
}

extension RichAttributes: Hashable {
    public func hash(into hasher: inout Hasher) {
        //        hasher.combine(id)
        hasher.combine(bold)
        hasher.combine(italic)
        hasher.combine(underline)
        hasher.combine(header)
        //        hasher.combine(list)
    }
}

extension RichAttributes: Equatable {
    public static func == (lhs: RichAttributes,
                           rhs: RichAttributes) -> Bool {
        return(
        //        lhs.id == rhs.id
        lhs.bold == rhs.bold
        && lhs.italic == rhs.italic
        && lhs.underline == rhs.underline
        && lhs.header == rhs.header
        //        && lhs.list == rhs.list
        )
    }
}

extension RichAttributes {
    public func copy(bold: Bool? = nil,
                     header: HeaderType? = nil,
                     italic: Bool? = nil,
                     underline: Bool? = nil
//                     list: ListType? = nil
    ) -> RichAttributes {
        return RichAttributes(
            bold: (bold != nil ? bold! : self.bold),
            italic: (italic != nil ? italic! : self.italic),
            underline: (underline != nil ? underline! : self.underline),
            header: (header != nil ? header! : self.header)
            //            list: (list != nil ? list! : self.list)
        )
    }
    
    public func copy(with style: TextSpanStyle, byAdding: Bool = true) -> RichAttributes {
        return copy(with: [style], byAdding: byAdding)
    }

    public func copy(with styles: [TextSpanStyle], byAdding: Bool = true) -> RichAttributes {
        let att = getRichAttributesFor(styles: styles)
        return RichAttributes(
            bold: (att.bold != nil ? (byAdding ? att.bold! : nil) : self.bold),
            italic: (att.italic != nil ? (byAdding ? att.italic! : nil) : self.italic),
            underline: (att.underline != nil ? (byAdding ? att.underline! : nil) : self.underline),
            header: (att.header != nil ? (byAdding ? att.header! : nil) : self.header)
            //            list: (att.list != nil ? (byAdding ? att.list! : nil) : self.list)
        )
    }
}

extension RichAttributes {
    public func styles() -> [TextSpanStyle] {
        var styles: [TextSpanStyle] = []
        if let bold = bold, bold {
            styles.append(.bold)
        }
        if let italic = italic, italic {
            styles.append(.italic)
        }
        if let underline = underline, underline {
            styles.append(.underline)
        }
        if let header = header {
            styles.append(header.getTextSpanStyle())
        }
        //        if let list = list {
        //            styles.append(.list(list))
        //        }
        return styles
    }

    public func stylesSet() -> Set<TextSpanStyle> {
        var styles: Set<TextSpanStyle> = []
        if let bold = bold, bold {
            styles.insert(.bold)
        }
        if let italic = italic, italic {
            styles.insert(.italic)
        }
        if let underline = underline, underline {
            styles.insert(.underline)
        }
        if let header = header {
            styles.insert(header.getTextSpanStyle())
        }
        //        if let list = list {
        //            styles.insert(.list(list))
        //        }
        return styles
    }
}

extension RichAttributes {
    public func hasStyle(style: RichTextStyle) -> Bool {
        switch style {
        case .default:
            return true
        case .bold:
            return bold ?? false
        case .italic:
            return italic ?? false
        case .underline:
            return underline ?? false
        case .h1:
            return header == .h1
        case .h2:
            return header == .h2
        case .h3:
            return header == .h3
        case .h4:
            return header == .h4
        case .h5:
            return header == .h5
        case .h6:
            return header == .h6
            //        case .bullet:
            //            return list == .bullet
            //        case .ordered:
            //            return list == .ordered

        }
    }
}

internal func getRichAttributesFor(style: RichTextStyle) -> RichAttributes {
    return getRichAttributesFor(styles: [style])
}

internal func getRichAttributesFor(styles: [RichTextStyle]) -> RichAttributes {
    guard !styles.isEmpty else { return RichAttributes() }
    var bold: Bool? = nil
    var italic: Bool? = nil
    var underline: Bool? = nil
    var header: HeaderType? = nil
    //        var list: ListType? = nil
    for style in styles {
        switch style {
        case .bold:
            bold = true
        case .italic:
            italic = true
        case .underline:
            underline = true
        case .h1:
            header = .h1
        case .h2:
            header = .h2
        case .h3:
            header = .h3
        case .h4:
            header = .h4
        case .h5:
            header = .h5
        case .h6:
            header = .h6
            //            case .list(let listType):
            //                list = listType
        case .default:
            header = .default
        }
    }
    return RichAttributes(bold: bold,
                          italic: italic,
                          underline: underline,
                          header: header
                          //                          list: list
    )
}
