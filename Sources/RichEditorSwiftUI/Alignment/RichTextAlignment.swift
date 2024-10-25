//
//  RichTextAlignment.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import SwiftUI

/**
 This enum defines supported rich text alignments, like left,
 right, center, and justified.
 */
public enum RichTextAlignment: String, CaseIterable, Codable, Equatable, Identifiable {

    /**
     Initialize a rich text alignment with a native alignment.

     - Parameters:
     - alignment: The native alignment to use.
     */
    public init(_ alignment: NSTextAlignment) {
        switch alignment {
            case .left: self = .left
            case .right: self = .right
            case .center: self = .center
            case .justified: self = .justified
            default: self = .left
        }
    }

    /// Left text alignment.
    case left

    /// Center text alignment.
    case center

    /// Justified text alignment.
    case justified

    /// Right text alignment.
    case right
}

public extension Collection where Element == RichTextAlignment {

    static var all: [Element] { RichTextAlignment.allCases }
}

public extension RichTextAlignment {

    /// The unique alignment ID.
    var id: String { rawValue }

    /// The standard icon to use for the alignment.
//    var icon: Image { nativeAlignment.icon }

    /// The standard title to use for the alignment.
//    var title: String { nativeAlignment.title }

    /// The standard title key to use for the alignment.
//    var titleKey: RTKL10n { nativeAlignment.titleKey }

    /// The native alignment of the alignment.
    var nativeAlignment: NSTextAlignment {
        switch self {
            case .left: .left
            case .right: .right
            case .center: .center
            case .justified: .justified
        }
    }
}

//extension NSTextAlignment: RichTextLabelValue {}

public extension NSTextAlignment {

//    /// The standard icon to use for the alignment.
//    var icon: Image {
//        switch self {
//            case .left: .richTextAlignmentLeft
//            case .right: .richTextAlignmentRight
//            case .center: .richTextAlignmentCenter
//            case .justified: .richTextAlignmentJustified
//            default: .richTextAlignmentLeft
//        }
//    }

}
