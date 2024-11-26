//
//  HeaderType.swift
//
//
//  Created by Divyesh Vekariya on 29/04/24.
//

import Foundation
import SwiftUI

public enum HeaderType: Int, CaseIterable, Codable, Equatable, Identifiable, RichTextLabelValue {
    case `default` = 0
    case h1 = 1
    case h2 = 2
    case h3 = 3
    case h4 = 4
    case h5 = 5
    case h6 = 6

    var titleLabel: String {
        switch self {
        case .default:
            return "Body"
        case .h1:
            return "H1"
        case .h2:
            return "H2"
        case .h3:
            return "H3"
        case .h4:
            return "H4"
        case .h5:
            return "H5"
        case .h6:
            return "H6"
        }
    }

    func getTextSpanStyle() -> RichTextSpanStyle {
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


public extension Collection where Element == HeaderType {

    static var all: [Element] { HeaderType.allCases }
}

public extension HeaderType {

    /// The unique header ID.
    var id: String { "\(rawValue)" }

    /// The standard icon to use for the header.
    var icon: Image {
        switch self {
        case .default: .richTextHeaderDefault
        case .h1: .richTextHeader1
        case .h2: .richTextHeader2
        case .h3: .richTextHeader3
        case .h4: .richTextHeader4
        case .h5: .richTextHeader5
        case .h6: .richTextHeader6
        }
    }

    /// standard title to use for the headers.
    var title: String { titleKey.text }

    /// The standard title key to use for the header.
    var titleKey: RTEL10n {
        switch self {
        case .default: .headerDefault
        case .h1: .header1
        case .h2: .header2
        case .h3: .header3
        case .h4: .header4
        case .h5: .header5
        case .h6: .header6
        }
    }
}
