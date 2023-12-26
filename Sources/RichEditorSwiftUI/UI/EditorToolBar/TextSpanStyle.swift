//
//  TextSpanStyle.swift
//  
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI

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
    
    var attributeValue: Any {
        switch self {
        case .default: 
            return UIFont()
        case .bold:
            return UIFont.boldSystemFont(ofSize: 12)
        case .italic:
            return UIFontDescriptor.SymbolicTraits.traitItalic
        case .underline:
            return NSUnderlineStyle.single
        case .h1:
            return UIFont.systemFont(ofSize: 20)
        case .h2:
            return UIFont.systemFont(ofSize: 18)
        case .h3:
            return UIFont.systemFont(ofSize: 16)
        case .h4:
            return UIFont.systemFont(ofSize: 14)
        case .h5:
            return UIFont.systemFont(ofSize: 12)
        case .h6:
            return UIFont.systemFont(ofSize: 10)
        }
    }
    
    var attributedStringKey: NSAttributedString.Key {
        switch self {
        case .default: return .font
        case .bold: return .font
        case .italic: return .font
        case .underline: return .underlineStyle
        case .h1: return .font
        case .h2: return .font
        case .h3: return .font
        case .h4: return .font
        case .h5: return .font
        case .h6: return .font
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
}

