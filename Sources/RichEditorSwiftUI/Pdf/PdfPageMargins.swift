//
//  PdfPageMargins.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import CoreGraphics

/// This error can be thrown when creating PDF data.
public struct PdfPageMargins: Equatable {

    /// Create PDF page margins.
    public init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }

    /// Create PDF page margins.
    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.top = vertical
        self.left = horizontal
        self.bottom = vertical
        self.right = horizontal
    }

    /// Create PDF page margins.
    public init(all: CGFloat) {
        self.top = all
        self.left = all
        self.bottom = all
        self.right = all
    }

    /// The top margins.
    public var top: CGFloat

    /// The left margins.
    public var left: CGFloat

    /// The bottom margins.
    public var bottom: CGFloat

    /// The right margins.
    public var right: CGFloat
}
