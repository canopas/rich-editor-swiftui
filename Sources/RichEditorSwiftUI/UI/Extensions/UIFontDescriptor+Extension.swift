//
//  UIFontDescriptor+Extension.swift
//  
//
//  Created by Divyesh Vekariya on 28/12/23.
//

import SwiftUI

extension UIFontDescriptor {
    /// Get a new font descriptor by toggling a text style.
    func byTogglingStyle(_ style: TextSpanStyle) -> UIFontDescriptor {
        guard let traits = style.symbolicTraits else { return self }
        if symbolicTraits.contains(traits) {
            return withSymbolicTraits(symbolicTraits.subtracting(traits)) ?? self
        } else {
            return withSymbolicTraits(symbolicTraits.union(traits)) ?? self
        }
    }
}
