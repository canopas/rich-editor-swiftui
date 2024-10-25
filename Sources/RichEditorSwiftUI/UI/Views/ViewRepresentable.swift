//
//  ViewRepresentable.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import SwiftUI

#if iOS || os(tvOS) || os(visionOS)
import UIKit

/**
 This typealias bridges platform-specific view representable
 types to simplify multi-platform support.
 */
typealias ViewRepresentable = UIViewRepresentable
#endif

#if macOS
import AppKit

/**
 This typealias bridges platform-specific view representable
 types to simplify multi-platform support.
 */
typealias ViewRepresentable = NSViewRepresentable
#endif
