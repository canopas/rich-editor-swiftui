//
//  RichTextImageAttachmentSize.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 23/12/24.
//

import CoreGraphics

/**
 This enum defines various ways to size images in rich text.
 */
public enum RichTextImageAttachmentSize {

    /// This size aims to make image fit the frame.
    case frame

    /// This size aims to make image fit the size in points.
    case points(CGFloat)
}

public extension RichTextImageAttachmentSize {

    /// The image's resulting height in a certain frame.
    func height(in frame: CGRect) -> CGFloat {
        switch self {
        case .frame: frame.height
        case .points(let points): points
        }
    }

    /// The image's resulting width in a certain frame.
    func width(in frame: CGRect) -> CGFloat {
        switch self {
        case .frame: frame.width
        case .points(let points): points
        }
    }
}
