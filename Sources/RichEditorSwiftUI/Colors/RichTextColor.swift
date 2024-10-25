//
//  RichTextColor.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import SwiftUI

/**
 This enum defines supported rich text color types.

 The enum makes the colors identifiable and diffable.
 */
public enum RichTextColor: String, CaseIterable, Codable, Equatable, Identifiable {

    /// Foreground color.
    case foreground

    /// Background color.
    case background

    /// Strikethrough color.
    case strikethrough

    /// Stroke color.
    case stroke

    /// Underline color.
    case underline
}

public extension RichTextColor {

    /// The unique color ID.
    var id: String { rawValue }

    /// The corresponding rich text attribute, if any.
    var attribute: NSAttributedString.Key? {
        switch self {
            case .foreground: .foregroundColor
            case .background: .backgroundColor
            case .strikethrough: .strikethroughColor
            case .stroke: .strokeColor
            case .underline: .underlineColor
        }
    }


    /// Adjust a `color` for a certain `colorScheme`.
    func adjust(
        _ color: Color?,
        for scheme: ColorScheme
    ) -> Color {
        switch self {
            case .background: color ?? .clear
            default: color ?? .primary
        }
    }
}

public extension Collection where Element == RichTextColor {

    static var allCases: [RichTextColor] { Element.allCases }
}
