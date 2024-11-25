//
//  NSMutableParagraphStyle+Custom.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 25/11/24.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

extension NSMutableParagraphStyle {

    convenience init(
        from style: NSMutableParagraphStyle? = nil,
        alignment: RichTextAlignment? = nil,
        indent: CGFloat? = nil,
        lineSpacing: CGFloat? = nil
    ) {
        let style = style ?? .init()
        self.init()
        self.alignment = alignment?.nativeAlignment ?? style.alignment
        self.lineSpacing = lineSpacing ?? style.lineSpacing
        self.headIndent = indent ?? style.headIndent
        self.firstLineHeadIndent = indent ?? style.headIndent
    }
}
