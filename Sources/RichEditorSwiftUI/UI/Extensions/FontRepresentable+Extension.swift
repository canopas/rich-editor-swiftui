//
//  FontRepresentable+Extension.swift
//
//
//  Created by Divyesh Vekariya on 26/12/23.
//

import SwiftUI

extension FontRepresentable {
    /// Check if font is bold
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    /// Check if font is italic
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    /// Make font **Bold**
    func makeBold() -> FontRepresentable {
        if isBold {
            return self
        } else {
            let fontDesc = fontDescriptor.byTogglingStyle(.bold)
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: pointSize)
        }
    }
    
    /// Make font **Italic**
    func makeItalic() -> FontRepresentable {
        if isItalic {
            return self
        } else {
            let fontDesc = fontDescriptor.byTogglingStyle(.italic)
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: pointSize)
        }
    }
    
    /// Make font **Bold** and **Italic**
    func setBoldItalicStyles() -> FontRepresentable {
        return makeBold().makeItalic()
    }
    
    /// Remove **Bold** style from font
    func removeBoldStyle() -> FontRepresentable {
        if !isBold {
            return self
        } else {
            let fontDesc = fontDescriptor.byTogglingStyle(.bold)
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: pointSize)
        }
    }
    
    /// Remove **Italic** style from font
    func removeItalicStyle() -> FontRepresentable {
        if !isItalic {
            return self
        } else {
            let fontDesc = fontDescriptor.byTogglingStyle(.italic)
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: pointSize)
        }
    }
    
    /// Remove **Bold** and **Italic** style from font
    func makeNormal() -> FontRepresentable {
        return removeBoldStyle().removeItalicStyle()
    }
    
    /// Toggle **Bold** style of font
    func toggleBoldTrait() -> FontRepresentable {
        if isBold {
            return removeBoldStyle()
        } else {
            return makeBold()
        }
    }
    
    /// Toggle **Italic** style of font
    func toggleItalicStyle() -> FontRepresentable {
        if isItalic {
            return removeItalicStyle()
        } else {
            return makeItalic()
        }
    }
    
    /// Get a new font with updated font size by **size**
    func updateFontSize(size: CGFloat) -> FontRepresentable {
        if pointSize != size {
            let fontDesc = fontDescriptor
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: size)
        } else {
            return self
        }
    }
    
    func updateFontSize(multiple: CGFloat) -> FontRepresentable {
        if pointSize != multiple * pointSize {
            let size = multiple * pointSize
            let fontDesc = fontDescriptor
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: size)
        } else {
            return self
        }
    }
}

public extension FontRepresentable {
    /// Get a new font by adding a text style.
    func addFontStyle(_ style: TextSpanStyle) -> FontRepresentable {
        guard let trait = style.symbolicTraits, !fontDescriptor.symbolicTraits.contains(trait) else { return self }
        let fontDesc = fontDescriptor.byTogglingStyle(style)
        fontDesc.withFamily(familyName)
        return FontRepresentable(descriptor: fontDesc, size: pointSize)
    }
    
    ///Get a new font by removing a text style.
    func removeFontStyle(_ style: TextSpanStyle) -> FontRepresentable {
        guard let trait = style.symbolicTraits, fontDescriptor.symbolicTraits.contains(trait) else { return self }
        let fontDesc = fontDescriptor.byTogglingStyle(style)
        fontDesc.withFamily(familyName)
        return FontRepresentable(descriptor: fontDesc, size: pointSize)
    }
    
    /// Get a new font by toggling a text style.
    func byToggalingFontStyle(_ style: TextSpanStyle) -> FontRepresentable {
        let fontDesc = fontDescriptor.byTogglingStyle(style)
        fontDesc.withFamily(familyName)
        return FontRepresentable(descriptor: fontDesc, size: pointSize)
    }
}
