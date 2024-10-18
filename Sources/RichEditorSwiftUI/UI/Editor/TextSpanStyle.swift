//
//  TextSpanStyle.swift
//  
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI

public typealias RichTextStyle = TextSpanStyle

public enum TextSpanStyle: Equatable, Codable, CaseIterable, Hashable {
    
    public static var allCases: [TextSpanStyle] = [
        .`default`,
        .bold,
        .italic,
        .underline,
        .strikethrough,
        .h1,
        .h2,
        .h3,
        .h4,
        .h5,
        .h6,
        .bullet()
    ]

    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        
        if case .bullet(let indent) = self {
            hasher.combine(indent)
        }
    }

    case `default`
    case bold
    case italic
    case underline
    case strikethrough
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
    case bullet(_ indent: Int? = nil)
//    case ordered(_ indent: Int? = nil)

    var key: String {
        switch self {
            case .default:
                return "default"
            case .bold:
                return "bold"
            case .italic:
                return "italic"
            case .underline:
                return "underline"
            case .strikethrough:
                return "strikethrough"
            case .h1:
                return "h1"
            case .h2:
                return "h2"
            case .h3:
                return "h3"
            case .h4:
                return "h4"
            case .h5:
                return "h5"
            case .h6:
                return "h6"
            case .bullet:
                return "bullet"
                //        case .ordered:
                //            return "ordered"
        }
    }

    func defaultAttributeValue(font: FontRepresentable? = nil) -> Any {
        let font = font ?? .systemFont(ofSize: .standardRichTextFontSize)
        switch self {
            case .underline:
                return NSUnderlineStyle.single.rawValue
            case .default, .bold, .italic, .h1, .h2, .h3, .h4, .h5, .h6:
                return getFontWithUpdating(font: font)
            case .bullet(let indent):
                return getListStyleAttributeValue(listType ?? .bullet(), indent: indent)
            case .strikethrough:
                return NSUnderlineStyle.single.rawValue
        }
    }

    var attributedStringKey: NSAttributedString.Key {
        switch self {
            case .underline:
                return .underlineStyle
            case .default, .bold, .italic, .h1, .h2, .h3, .h4, .h5, .h6:
                return .font
            case .bullet:
                return .paragraphStyle
            case .strikethrough:
                return .strikethroughStyle
        }
    }

    public static func == (lhs: TextSpanStyle, rhs: TextSpanStyle) -> Bool {
        return lhs.key == rhs.key
    }

    var editorTools: EditorTool? {
        switch self {
            case .default:
                return .none
            case .bold:
                return .bold
            case .italic:
                return .italic
            case .underline:
                return .underline
            case .strikethrough:
                return .strikethrough
            case .bullet(let indent):
                return .list(.bullet(indent))
            case .h1:
                return .header(.h1)
            case .h2:
                return .header(.h2)
            case .h3:
                return .header(.h3)
            case .h4:
                return .header(.h4)
            case .h5:
                return .header(.h5)
            case .h6:
                return .header(.h6)
        }
    }

    var listType: ListType? {
        switch self {
        case .bullet(let indent):
            return .bullet(indent)
        default:
            return nil
        }
    }

    var isHeaderStyle: Bool {
        switch self {
        case .h1, .h2, .h3, .h4, .h5, .h6:
            return true
        default:
            return false
        }
    }

    var isList: Bool {
        switch self {
        case .bullet:
            return true
        default:
            return false
        }
    }

    var isDefault: Bool {
        switch self {
        case .default:
            return true
        default:
            return false
        }
    }

    func getFontWithUpdating(font: FontRepresentable) -> FontRepresentable {
        switch self {
            case .default:
                return font
            case .bold,.italic:
                return font.addFontStyle(self)
            case .underline, .bullet, .strikethrough:
                return font
            case .h1:
                return font.updateFontSize(multiple: 1.5)
            case .h2:
                return font.updateFontSize(multiple: 1.4)
            case .h3:
                return font.updateFontSize(multiple: 1.3)
            case .h4:
                return font.updateFontSize(multiple: 1.2)
            case .h5:
                return font.updateFontSize(multiple: 1.1)
            case .h6:
                return font.updateFontSize(multiple: 1)
        }
    }

    var fontSizeMultiplier: CGFloat {
        switch self {
        case .h1:
            return 1.5
        case .h2:
            return 1.4
        case .h3:
            return 1.3
        case .h4:
            return 1.2
        case .h5:
            return 1.1
        default:
            return 1
        }
    }

    func getFontAfterRemovingStyle(font: FontRepresentable) -> FontRepresentable {
        switch self {
        case .bold, .italic, .bullet:
            return font.removeFontStyle(self)
            case .underline, .strikethrough:
            return font
        case .default, .h1, .h2, .h3, .h4, .h5, .h6:
            return font.updateFontSize(size: .standardRichTextFontSize)
        }
    }

    func getListStyleAttributeValue(_ listType: ListType, indent: Int? = nil) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let listItem = NSTextList(markerFormat: listType.getMarkerFormat(), options: 0)
        paragraphStyle.textLists = Array(repeating: listItem, count: (indent ?? 0) + 1)
        return paragraphStyle
    }
}

extension TextSpanStyle {

    /// The symbolic font traits for the style, if any.
    var symbolicTraits: FontTraitsRepresentable? {
        switch self {
        case .bold:
            return .traitBold
        case .italic:
            return .traitItalic
        default:
            return nil
        }
    }
}

extension TextSpanStyle {
    func getRichAttribute() -> RichAttributes? {
        switch self {
            case .default:
                return nil
            case .bold:
                return RichAttributes(bold: true)
            case .italic:
                return RichAttributes(italic: true)
            case .underline:
                return RichAttributes(underline: true)
            case .strikethrough:
                return RichAttributes(strike: true)
            case .bullet:
                return RichAttributes(list: .bullet())
            case .h1:
                return RichAttributes(header: .h1)
            case .h2:
                return RichAttributes(header: .h2)
            case .h3:
                return RichAttributes(header: .h3)
            case .h4:
                return RichAttributes(header: .h4)
            case .h5:
                return RichAttributes(header: .h5)
            case .h6:
                return RichAttributes(header: .h6)
        }
    }
}


public extension Collection where Element == RichTextStyle {

    /**
     Whether or not the collection contains a certain style.

     - Parameters:
     - style: The style to look for.
     */
    func hasStyle(_ style: RichTextStyle) -> Bool {
        contains(style)
    }
}
