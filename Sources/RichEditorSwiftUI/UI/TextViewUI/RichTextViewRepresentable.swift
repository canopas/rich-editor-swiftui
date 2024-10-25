//
//  RichTextViewRepresentable.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

#if macOS
import AppKit

/// This typealias bridges UIKit & AppKit native text views.
public typealias RichTextViewRepresentable = NSTextView
#endif

#if iOS || os(tvOS) || os(visionOS)
import UIKit

/// This typealias bridges UIKit & AppKit native text views.
public typealias RichTextViewRepresentable = UITextView
#endif
