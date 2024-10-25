//
//  ListType.swift
//  
//
//  Created by Divyesh Vekariya on 29/04/24.
//

import Foundation

public enum ListType: Codable, Identifiable, CaseIterable, Hashable {
    public static var allCases: [ListType] = [.bullet()]

    public var id: String {
        return key
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(getIndent())
    }

    case bullet(_ indent: Int? = nil)
//    case ordered(_ indent: Int? = nil)

    enum CodingKeys: String, CodingKey {
        case bullet = "bullet"
//        case ordered = "ordered"
    }

    var key: String {
        switch self {
        case .bullet:
            return "bullet"
//        case .ordered:
//            return "ordered"
        }
    }
}

extension ListType {
    func getTextSpanStyle() -> TextSpanStyle {
        switch self {
        case .bullet(let indent):
            return .bullet(indent)
//        case .ordered:
//            return .ordered
        }
    }

    func getMarkerFormat() -> TextList.MarkerFormat {
        switch self {
        case .bullet:
            return .disc
//        case .ordered:
//            return .decimal
        }
    }

    func getIndent() -> Int {
        switch self {
        case .bullet(let indent):
            return indent ?? 0
//        case .ordered(let indent):
//            return indent ?? 0
        }
    }

//    func moveIndentForward() -> ListType {
//        switch self {
//        case .bullet(let indent):
//            let newIndent = (indent ?? 0) + 1
//            return .bullet(newIndent)
//        }
//    }
//
//    func moveIndentBackward() -> ListType {
//        switch self {
//        case .bullet(let indent):
//            let newIndent = max(0, ((indent ?? 0) - 1))
//            return .bullet(newIndent)
//        }
//    }
}


#if canImport(UIKit)
import UIKit

typealias TextList = NSTextList
#endif

#if canImport(AppKit)
import AppKit

typealias TextList = NSTextList
#endif
