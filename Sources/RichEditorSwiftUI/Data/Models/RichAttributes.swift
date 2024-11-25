//
//  RichAttributes.swift
//
//
//  Created by Divyesh Vekariya on 04/04/24.
//

import SwiftUI

// MARK: - RichAttributes
public struct RichAttributes: Codable {
    //    public let id: String
    public let bold: Bool?
    public let italic: Bool?
    public let underline: Bool?
    public let strike: Bool?
    public let header: HeaderType?
    public let list: ListType?
    public let indent: Int?
    public let size: Int?
    public let font: String?
    public let color: String?
    public let background: String?
    public let align: RichTextAlignment?

    public init(
        //        id: String = UUID().uuidString,
        bold: Bool? = nil,
        italic: Bool? = nil,
        underline: Bool? = nil,
        strike: Bool? = nil,
        header: HeaderType? = nil,
        list: ListType? = nil,
        indent: Int? = nil,
        size: Int? = nil,
        font: String? = nil,
        color: String? = nil,
        background: String? = nil,
        align: RichTextAlignment? = nil
    ) {
        //        self.id = id
        self.bold = bold
        self.italic = italic
        self.underline = underline
        self.strike = strike
        self.header = header
        self.list = list
        self.indent = indent
        self.size = size
        self.font = font
        self.color = color
        self.background = background
        self.align = align
    }

    enum CodingKeys: String, CodingKey {
        case bold = "bold"
        case italic = "italic"
        case underline = "underline"
        case strike = "strike"
        case header = "header"
        case list = "list"
        case indent = "indent"
        case size = "size"
        case font = "font"
        case color = "color"
        case background = "background"
        case align = "align"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        //        self.id = UUID().uuidString
        self.bold = try values.decodeIfPresent(Bool.self, forKey: .bold)
        self.italic = try values.decodeIfPresent(Bool.self, forKey: .italic)
        self.underline = try values.decodeIfPresent(Bool.self, forKey: .underline)
        self.strike = try values.decodeIfPresent(Bool.self, forKey: .strike)
        self.header = try values.decodeIfPresent(HeaderType.self, forKey: .header)
        self.list = try values.decodeIfPresent(ListType.self, forKey: .list)
        self.indent = try values.decodeIfPresent(Int.self, forKey: .indent)
        self.size = try values.decodeIfPresent(Int.self, forKey: .size)
        self.font = try values.decodeIfPresent(String.self, forKey: .font)
        self.color = try values.decodeIfPresent(String.self, forKey: .color)
        self.background = try values.decodeIfPresent(String.self, forKey: .background)
        self.align = try values.decodeIfPresent(RichTextAlignment.self, forKey: .align)
    }
}

extension RichAttributes: Hashable {
    public func hash(into hasher: inout Hasher) {
        //        hasher.combine(id)
        hasher.combine(bold)
        hasher.combine(italic)
        hasher.combine(underline)
        hasher.combine(strike)
        hasher.combine(header)
        hasher.combine(list)
        hasher.combine(indent)
        hasher.combine(size)
        hasher.combine(font)
        hasher.combine(color)
        hasher.combine(background)
        hasher.combine(align)
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
        && lhs.strike == rhs.strike
        && lhs.header == rhs.header
        && lhs.list == rhs.list
        && lhs.indent == rhs.indent
        && lhs.size == rhs.size
        && lhs.font == rhs.font
        && lhs.color == rhs.color
        && lhs.background == rhs.background
        && lhs.align == rhs.align
        )
    }
}

extension RichAttributes {
    public func copy(bold: Bool? = nil,
                     header: HeaderType? = nil,
                     italic: Bool? = nil,
                     underline: Bool? = nil,
                     strike: Bool? = nil,
                     list: ListType? = nil,
                     indent: Int? = nil,
                     size: Int? = nil,
                     font: String? = nil,
                     color: String? = nil,
                     background: String? = nil,
                     align: RichTextAlignment? = nil
    ) -> RichAttributes {
        return RichAttributes(
            bold: (bold != nil ? bold! : self.bold),
            italic: (italic != nil ? italic! : self.italic),
            underline: (underline != nil ? underline! : self.underline),
            strike: (strike != nil ? strike! : self.strike),
            header: (header != nil ? header! : self.header),
            list: (list != nil ? list! : self.list),
            indent: (indent != nil ? indent! : self.indent),
            size: (size != nil ? size! : self.size),
            font: (font != nil ? font! : self.font),
            color: (color != nil ? color! : self.color),
            background: (background != nil ? background! : self.background),
            align: (align != nil ? align! : self.align)
        )
    }
    
    public func copy(with style: RichTextSpanStyle, byAdding: Bool = true) -> RichAttributes {
        return copy(with: [style], byAdding: byAdding)
    }

    public func copy(with styles: [RichTextSpanStyle], byAdding: Bool = true) -> RichAttributes {
        let att = getRichAttributesFor(styles: styles)
        return RichAttributes(
            bold: (att.bold != nil ? (byAdding ? att.bold! : nil) : self.bold),
            italic: (att.italic != nil ? (byAdding ? att.italic! : nil) : self.italic),
            underline: (att.underline != nil ? (byAdding ? att.underline! : nil) : self.underline),
            strike: (att.strike != nil ? (byAdding ? att.strike! : nil) : self.strike),
            header: (att.header != nil ? (byAdding ? att.header! : nil) : self.header),
            list: (att.list != nil ? (byAdding ? att.list! : nil) : self.list),
            indent: (att.indent != nil ? (byAdding ? att.indent! : nil) : self.indent),
            size: (att.size != nil ? (byAdding ? att.size! : nil) : self.size),
            font: (att.font != nil ? (byAdding ? att.font! : nil) : self.font),
            color: (att.color != nil ? (byAdding ? att.color! : nil) : self.color),
            background: (att.background != nil ? (byAdding ? att.background! : nil) : self.background),
            align: (att.align != nil ? (byAdding ? att.align! : nil) : self.align)
        )
    }
}

extension RichAttributes {
    public func styles() -> [RichTextSpanStyle] {
        var styles: [RichTextSpanStyle] = []
        if let bold = bold, bold {
            styles.append(.bold)
        }
        if let italic = italic, italic {
            styles.append(.italic)
        }
        if let underline = underline, underline {
            styles.append(.underline)
        }
        if let strike = strike, strike {
            styles.append(.strikethrough)
        }
        if let header = header {
            styles.append(header.getTextSpanStyle())
        }
        if let list = list {
            styles.append(list.getTextSpanStyle())
        }
        if let size = size {
            styles.append(.size(size))
        }
        if let font = font {
            styles.append(.font(font))
        }
        if let color = color {
            styles.append(.color(.init(hex: color)))
        }
        if let background = background {
            styles.append(.background(.init(hex: background)))
        }
        if let align = align {
            styles.append(.align(align))
        }
        return styles
    }

    public func stylesSet() -> Set<RichTextSpanStyle> {
        var styles: Set<RichTextSpanStyle> = []
        if let bold = bold, bold {
            styles.insert(.bold)
        }
        if let italic = italic, italic {
            styles.insert(.italic)
        }
        if let underline = underline, underline {
            styles.insert(.underline)
        }
        if let strike = strike, strike {
            styles.insert(.strikethrough)
        }
        if let header = header {
            styles.insert(header.getTextSpanStyle())
        }
        if let list = list {
            styles.insert(list.getTextSpanStyle())
        }
        if let size = size {
            styles.insert(.size(size))
        }
        if let font = font {
            styles.insert(.font(font))
        }
        if let color = color {
            styles.insert(.color(Color(hex: color)))
        }
        if let background = background {
            styles.insert(.background(Color(hex: background)))
        }
        if let align = align {
            styles.insert(.align(align))
        }
        return styles
    }
}

extension RichAttributes {
    public func hasStyle(style: RichTextSpanStyle) -> Bool {
        switch style {
        case .default:
            return true
        case .bold:
            return bold ?? false
        case .italic:
            return italic ?? false
        case .underline:
            return underline ?? false
        case .strikethrough:
            return strike ?? false
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
        case .bullet:
            return list == .bullet(indent)
        case .size(let size):
            return size == size
        case .font(let name):
            return font == name
        case .color(let colorItem):
            return color == colorItem?.hexString
        case .background(let color):
            return background == color?.hexString
        case .align(let alignment):
            return align == alignment
        }
    }
}

internal func getRichAttributesFor(style: RichTextSpanStyle) -> RichAttributes {
    return getRichAttributesFor(styles: [style])
}

internal func getRichAttributesFor(styles: [RichTextSpanStyle]) -> RichAttributes {
    guard !styles.isEmpty else { return RichAttributes() }
    var bold: Bool? = nil
    var italic: Bool? = nil
    var underline: Bool? = nil
    var strike: Bool? = nil
    var header: HeaderType? = nil
    var list: ListType? = nil
    var indent: Int? = nil
    var size: Int? = nil
    var font: String? = nil
    var color: String? = nil
    var background: String? = nil
    var align: RichTextAlignment? = nil

    for style in styles {
        switch style {
            case .bold:
                bold = true
            case .italic:
                italic = true
            case .underline:
                underline = true
            case .strikethrough:
                strike = true
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
            case .bullet(let indentIndex):
                list = .bullet(indentIndex)
                indent = indentIndex
            case .default:
                header = .default
            case .size(let fontSize):
                size = fontSize
            case .font(let name):
                font = name
            case .color(let textColor):
            color = textColor?.hexString
            case .background(let backgroundColor):
            background = backgroundColor?.hexString
        case .align(let alignment):
            align = alignment
        }
    }
    return RichAttributes(bold: bold,
                          italic: italic,
                          underline: underline,
                          strike: strike,
                          header: header,
                          list: list,
                          indent: indent,
                          size: size,
                          font: font,
                          color: color,
                          background: background,
                          align: align
    )
}
