//
//  FontDescriptorRepresentable.swift
//  
//
//  Created by Divyesh Vekariya on 17/01/24.
//

import Foundation

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

/**
 This typealias bridges platform-specific font descriptors.
 
 The typealias also defines additional functionality as type
 extensions for the platform-specific types.
 */
public typealias FontDescriptorRepresentable = NSFontDescriptor

public extension FontDescriptorRepresentable {
    
    /// Get a new font descriptor by toggling a text style.
    func byTogglingStyle(_ style: RichTextStyle) -> FontDescriptorRepresentable {
        guard let traits = style.symbolicTraits else { return self }
        if symbolicTraits.contains(traits) {
            return withSymbolicTraits(symbolicTraits.subtracting(traits))
        } else {
            return withSymbolicTraits(symbolicTraits.union(traits))
        }
    }
}
#endif

#if canImport(UIKit)
import UIKit

/**
 This typealias bridges platform-specific font descriptors.
 
 The typealias also defines additional functionality as type
 extensions for the platform-specific types.
 */
public typealias FontDescriptorRepresentable = UIFontDescriptor

public extension FontDescriptorRepresentable {
    
    /// Get a new font descriptor by toggling a text style.
    func byTogglingStyle(_ style: RichTextStyle) -> FontDescriptorRepresentable {
        guard let traits = style.symbolicTraits else { return self }
        if symbolicTraits.contains(traits) {
            return withSymbolicTraits(symbolicTraits.subtracting(traits)) ?? self
        } else {
            return withSymbolicTraits(symbolicTraits.union(traits)) ?? self
        }
    }
}
#endif
