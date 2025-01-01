//
//  PasteboardImageReader.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 23/12/24.
//

import Foundation

/**
 This protocol can be implemented by types that can fetch an
 image or multiple images from the pasteboard.

 The protocol is implemented by the UIKit `UIPasteboard`, as
 well as the AppKit `NSPasteboard`.
 */
public protocol PasteboardImageReader {

    /// Get the first image in the pasteboard, if any.
    var image: ImageRepresentable? { get }

    /// Get all images in the pasteboard.
    var images: [ImageRepresentable]? { get }
}

public extension PasteboardImageReader {

    /// Check whether or not the pasteboard han any images.
    var hasImages: Bool {
        guard let images = images else { return false }
        return !images.isEmpty
    }
}

#if iOS || os(visionOS)
import UIKit

extension UIPasteboard: PasteboardImageReader {}
#endif

#if macOS
import AppKit

extension NSPasteboard: PasteboardImageReader {}

public extension NSPasteboard {

    /// Get the first image in the pasteboard, if any.
    var image: ImageRepresentable? {
        images?.first
    }

    /// Get all images in the pasteboard.
    var images: [ImageRepresentable]? {
        readObjects(forClasses: [NSImage.self]) as? [NSImage]
    }
}
#endif
