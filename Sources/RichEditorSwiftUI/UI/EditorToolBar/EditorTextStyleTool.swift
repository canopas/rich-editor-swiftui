//
//  EditorTextStyleTool.swift
//
//
//  Created by Divyesh Vekariya on 19/12/23.
//

import SwiftUI

enum EditorTextStyleTool: CaseIterable, Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
//        if case .list(let listType) = self {
//            hasher.combine(listType?.key)
//            hasher.combine(listType?.getIndent())
//        }
    }

    static var allCases: [EditorTextStyleTool] {
        return [
            .header(),
            .bold,
            .italic,
            .underline,
            .strikethrough,
//            .list(.bullet())
        ]
    }

    case header(HeaderType? = nil)
    case bold
    case italic
    case underline
    case strikethrough
//    case list(ListType? = .bullet())

    var systemImageName: String {
        switch self {
            case .header:
                return "textformat.size"
            case .bold:
                return "bold"
            case .italic:
                return "italic"
            case .underline:
                return "underline"
            case .strikethrough:
                return "strikethrough"
//            case .list:
//                return "list.bullet"
        }
    }

    var isContainManu: Bool {
        switch self {
        case .header:
            return true
        default:
            return false
        }
    }

    func getTextSpanStyle() -> RichTextSpanStyle {
        switch self {
        case .header(let headerOptions):
            switch headerOptions {
            case .default: return .default
            case .h1: return .h1
            case .h2: return .h2
            case .h3: return .h3
            case .h4: return .h4
            case .h5: return .h5
            case .h6: return .h6
            case .none:
                return .default
            }
        case .bold:
            return .bold
        case .italic:
            return .italic
        case .underline:
            return .underline
        case .strikethrough:
            return .strikethrough
//        case .list(let listType):
//            return listType?.getTextSpanStyle() ?? .default
        }
    }

    func isSelected(_ currentStyle: Set<RichTextSpanStyle>) -> Bool {
        switch self {
            case .header:
                return currentStyle.contains(.h1) || currentStyle.contains(.h2) || currentStyle.contains(.h3) || currentStyle.contains(.h4) || currentStyle.contains(.h5) || currentStyle.contains(.h6)
            case .bold:
                return currentStyle.contains(.bold)
            case .italic:
                return currentStyle.contains(.italic)
            case .underline:
                return currentStyle.contains(.underline)
            case .strikethrough:
                return currentStyle.contains(.strikethrough)
//            case .list:
//                return currentStyle.contains(.bullet())
        }
    }

    var key: String {
        switch self {
            case .header:
                return "header"
            case .bold:
                return "bold"
            case .italic:
                return "italic"
            case .underline:
                return "underline"
            case .strikethrough:
                return "strikethrough"
//            case .list:
//                return "list"
        }
    }
}
