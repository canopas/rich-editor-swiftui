//
//  FontTraitsRepresentable.swift
//  
//
//  Created by Divyesh Vekariya on 28/12/23.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

/**
 This typealias bridges platform-specific symbolic traits to
 simplify multi-platform support.
 
 The typealias also defines additional functionality as type
 extensions for the platform-specific types.
 */
public typealias FontTraitsRepresentable = NSFontDescriptor.SymbolicTraits
#endif

#if canImport(UIKit)
import UIKit

/**
 This typealias bridges platform-specific symbolic traits to
 simplify multi-platform support.
 
 The typealias also defines additional functionality as type
 extensions for the platform-specific types.
 */
public typealias FontTraitsRepresentable = UIFontDescriptor.SymbolicTraits
#endif

public extension FontTraitsRepresentable {
    
    /**
     Get the rich text styles that are enabled in the traits.
     
     Note that the traits only contain some of the available
     rich text styles.
     */
    var enabledRichTextStyles: [RichTextStyle] {
        RichTextStyle.allCases.filter {
            guard let trait = $0.symbolicTraits else { return false }
            return contains(trait)
        }
    }
}
