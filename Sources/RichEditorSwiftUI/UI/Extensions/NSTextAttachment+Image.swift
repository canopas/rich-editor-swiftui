//
//  NSTextAttachment+Image.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 23/12/24.
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

#if iOS || macOS || os(tvOS) || os(visionOS)
public extension NSTextAttachment {

    /**
     Get an `image` value, if any, or use `contents` data to
     create a platform-specific image.

     This additional handling is needed since the `image` is
     not always available on certain platforms.
     */
    var attachedImage: ImageRepresentable? {
        if let image { return image }
        guard let contents else { return nil }
        return ImageRepresentable(data: contents)
    }
}
#endif
