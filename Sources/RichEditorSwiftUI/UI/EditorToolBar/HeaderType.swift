//
//  HeaderType.swift
//
//
//  Created by Divyesh Vekariya on 29/04/24.
//

import Foundation

public enum HeaderType: Int, CaseIterable, Codable {
    case `default` = 0
    case h1 = 1
    case h2 = 2
    case h3 = 3
    case h4 = 4
    case h5 = 5
    case h6 = 6

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
