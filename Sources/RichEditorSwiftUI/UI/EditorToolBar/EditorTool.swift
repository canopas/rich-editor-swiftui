//
//  EditorTool.swift
//
//
//  Created by Divyesh Vekariya on 19/12/23.
//

import SwiftUI

enum EditorTool: CaseIterable, Hashable {
    static var allCases: [EditorTool] {
        return [.header(), .bold, .italic, .underline, .list(.bullet)]
    }

    case header(HeaderType? = nil), bold, italic, underline, list(ListType? = .bullet)

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
        case .list:
            return "list.bullet"
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

    func getTextSpanStyle() -> TextSpanStyle {
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
        case .list(let listType):
            return listType?.getTextSpanStyle() ?? .default
        }
    }

    func isSelected(_ currentStyle: Set<TextSpanStyle>) -> Bool {
        switch self {
        case .header:
            return currentStyle.contains(.h1) || currentStyle.contains(.h2) || currentStyle.contains(.h3) || currentStyle.contains(.h4) || currentStyle.contains(.h5) || currentStyle.contains(.h6)
        case .bold:
            return currentStyle.contains(.bold)
        case .italic:
            return currentStyle.contains(.italic)
        case .underline:
            return currentStyle.contains(.underline)
        case .list:
            return currentStyle.contains(.bullet)
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
        case .list:
            return "list"
        }
    }
}
