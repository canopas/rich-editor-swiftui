//
//  TextSpanStyle.swift
//  
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI

public typealias RichTextStyle = TextSpanStyle

public enum TextSpanStyle: String, Equatable, Codable, CaseIterable {
    case `default`   = "default"
    case bold        = "bold"
    case italic      = "italic"
    case underline   = "underline"
    case h1          = "h1"
    case h2          = "h2"
    case h3          = "h3"
    case h4          = "h4"
    case h5          = "h5"
    case h6          = "h6"

    var key: String {
        return self.rawValue
    }

    func defaultAttributeValue(font: FontRepresentable? = nil) -> Any {
        let font = font ?? .systemFont(ofSize: .standardRichTextFontSize)
        switch self {
        case .underline:
            return 1
        case .default, .bold, .italic, .h1, .h2, .h3, .h4, .h5, .h6:
            return getFontWithUpdating(font: font)
        }
    }

    var attributedStringKey: NSAttributedString.Key {
        switch self {
        case .underline: return .underlineStyle
        case .default, .bold, .italic, .h1, .h2, .h3, .h4, .h5, .h6:
            return .font
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

    var isHeaderStyle: Bool {
        switch self {
        case .h1, .h2, .h3, .h4, .h5, .h6:
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
        case .underline:
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
        case .bold, .italic:
            return font.removeFontStyle(self)
        case .underline:
            return font
        case .default, .h1, .h2, .h3, .h4, .h5, .h6:
            return font.updateFontSize(size: .standardRichTextFontSize)
        }
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
