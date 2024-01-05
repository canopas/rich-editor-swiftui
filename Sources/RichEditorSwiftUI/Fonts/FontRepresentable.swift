//
//  FontRepresentable.swift
//
//
//  Created by Divyesh Vekariya on 28/12/23.
//

#if canImport(UIKit)
import UIKit

/**
 This typealias bridges platform-specific fonts, to simplify
 multi-platform support.
 */
public typealias FontRepresentable = UIFont
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

/**
 This typealias bridges platform-specific fonts, to simplify
 multi-platform support.
 */
public typealias FontRepresentable = NSFont
#endif
