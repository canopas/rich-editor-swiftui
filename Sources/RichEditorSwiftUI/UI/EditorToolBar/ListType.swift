//
//  ListType.swift
//  
//
//  Created by Divyesh Vekariya on 29/04/24.
//

import Foundation


public enum ListType: String, Codable {
    case bullet         = "bullet"
//    case ordered        = "ordered"
}

extension ListType {
    func getTextSpanStyle() -> TextSpanStyle {
        switch self {
        case .bullet:
            return .bullet
//        case .ordered:
//            return .ordered
        }
    }
}
