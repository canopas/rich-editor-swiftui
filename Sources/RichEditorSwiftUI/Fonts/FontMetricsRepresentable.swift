//
//  File.swift
//  
//
//  Created by Divyesh Vekariya on 17/01/24.
//

import Foundation

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

/**
 This typealias bridges platform-specific font matrics to
 simplify multi-platform support.
 
 The typealias also defines additional functionality as type
 extensions for the platform-specific types.
 */
public typealias FontMetricsRepresentable = NSFont.NSFontMetrics
#endif

#if canImport(UIKit)
import UIKit

/**
 This typealias bridges platform-specific font matrics to
 simplify multi-platform support.
 
 The typealias also defines additional functionality as type
 extensions for the platform-specific types.
 */
public typealias FontMetricsRepresentable = UIFontMetrics
#endif
