//
//  ColorRepresentable.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

#if macOS
    import AppKit

    /// This typealias bridges platform-specific colors to simplify
    /// multi-platform support.
    public typealias ColorRepresentable = NSColor
#endif

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    import UIKit

    /// This typealias bridges platform-specific colors to simplify
    /// multi-platform support.
    public typealias ColorRepresentable = UIColor
#endif

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    extension ColorRepresentable {

        #if os(iOS) || os(tvOS) || os(visionOS)
            public static var textColor: ColorRepresentable { .label }
        #endif
    }
#endif
