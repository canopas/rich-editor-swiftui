//
//  EditorTool.swift
//
//
//  Created by Divyesh Vekariya on 19/12/23.
//

import SwiftUI

enum EditorTool: CaseIterable, Hashable {
    static var allCases: [EditorTool] {
        return [.header(), .bold, .italic, .underline]
    }
    
    case header(HeaderOptions? = nil), bold, italic, underline
    
    var systemImageName: String {
        switch self {
        case .header: return "textformat.size"
        case .bold: return "bold"
        case .italic: return "italic"
        case .underline: return "underline"
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
        }
    }
}

enum HeaderOptions: CaseIterable {
    case `default`, h1, h2, h3, h4, h5, h6
    
    var title: String {
        switch self {
        case .default:
            return "Normal Text"
        case .h1:
            return "Header 1"
        case .h2:
            return "Header 2"
        case .h3:
            return "Header 3"
        case .h4:
            return "Header 4"
        case .h5:
            return "Header 5"
        case .h6:
            return "Header 6"
        }
    }
    
    func getTextSpanStyle() -> TextSpanStyle {
        switch self {
        case .default: return .default
        case .h1: return .h1
        case .h2: return .h2
        case .h3: return .h3
        case .h4: return .h4
        case .h5: return .h5
        case .h6: return .h6
        }
    }
}
