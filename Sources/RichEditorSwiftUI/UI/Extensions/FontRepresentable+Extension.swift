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
#if os(macOS)
        return fontDescriptor.symbolicTraits.contains(.bold)
#else
        return fontDescriptor.symbolicTraits.contains(.traitBold)
#endif

    }
    
    /// Check if font is italic
    var isItalic: Bool {
#if os(macOS)
        return fontDescriptor.symbolicTraits.contains(.italic)
#else
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
#endif
    }
    
    /// Make font **Bold**
    func makeBold() -> FontRepresentable {
        if isBold {
            return self
        } else {
            let fontDesc = fontDescriptor.byTogglingStyle(.bold)
#if os(macOS)
            if let familyName {
                fontDesc.withFamily(familyName)
            }
            return FontRepresentable(
                descriptor: fontDesc,
                size: pointSize
            ) ?? self
#else
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: pointSize)
#endif
        }
    }
    
    /// Make font **Italic**
    func makeItalic() -> FontRepresentable {
        if isItalic {
            return self
        } else {
            let fontDesc = fontDescriptor.byTogglingStyle(.italic)
#if os(macOS)
            if let familyName {
                fontDesc.withFamily(familyName)
            }
            return FontRepresentable(
                descriptor: fontDesc,
                size: pointSize
            ) ?? self
#else
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: pointSize)
#endif
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
#if os(macOS)
            if let familyName {
                fontDesc.withFamily(familyName)
            }
            return FontRepresentable(
                descriptor: fontDesc,
                size: pointSize
            ) ?? self
#else
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: pointSize)
#endif
        }
    }
    
    /// Remove **Italic** style from font
    func removeItalicStyle() -> FontRepresentable {
        if !isItalic {
            return self
        } else {
            let fontDesc = fontDescriptor.byTogglingStyle(.italic)
#if os(macOS)
            if let familyName {
                fontDesc.withFamily(familyName)
            }
            return FontRepresentable(
                descriptor: fontDesc,
                size: pointSize
            ) ?? self
#else
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: pointSize)
#endif
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
#if os(macOS)
            if let familyName {
                fontDesc.withFamily(familyName)
            }
            return FontRepresentable(
                descriptor: fontDesc,
                size: size
            ) ?? self
#else
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: size)
#endif
        } else {
            return self
        }
    }
    
    func updateFontSize(multiple: CGFloat) -> FontRepresentable {
        if pointSize != multiple * pointSize {
            let size = multiple * pointSize
            let fontDesc = fontDescriptor
#if os(macOS)
            if let familyName {
                fontDesc.withFamily(familyName)
            }
            return FontRepresentable(
                descriptor: fontDesc,
                size: size
            ) ?? self
#else
            fontDesc.withFamily(familyName)
            return FontRepresentable(descriptor: fontDesc, size: size)
#endif
        } else {
            return self
        }
    }
}

public extension FontRepresentable {
    /// Get a new font by adding a text style.
    func addFontStyle(_ style: RichTextSpanStyle) -> FontRepresentable {
        guard let style = style.richTextStyle, let trait = style.symbolicTraits, !fontDescriptor.symbolicTraits.contains(trait) else { return self }
        let fontDesc = fontDescriptor.byTogglingStyle(style)
#if os(macOS)
        if let familyName {
            fontDesc.withFamily(familyName)
        }
        return FontRepresentable(
            descriptor: fontDesc,
            size: pointSize
        ) ?? self
#else
        fontDesc.withFamily(familyName)
        return FontRepresentable(descriptor: fontDesc, size: pointSize)
#endif
    }
    
    ///Get a new font by removing a text style.
    func removeFontStyle(_ style: RichTextSpanStyle) -> FontRepresentable {
        guard let style = style.richTextStyle, let trait = style.symbolicTraits, fontDescriptor.symbolicTraits.contains(trait) else { return self }
        let fontDesc = fontDescriptor.byTogglingStyle(style)
#if os(macOS)
        if let familyName {
            fontDesc.withFamily(familyName)
        }
        return FontRepresentable(
            descriptor: fontDesc,
            size: pointSize
        ) ?? self
#else
        fontDesc.withFamily(familyName)
        return FontRepresentable(descriptor: fontDesc, size: pointSize)
#endif
    }
    
    /// Get a new font by toggling a text style.
    func byTogglingFontStyle(_ style: RichTextSpanStyle) -> FontRepresentable {
        guard let style = style.richTextStyle else { return self }
        let fontDesc = fontDescriptor.byTogglingStyle(style)
#if os(macOS)
        if let familyName {
            fontDesc.withFamily(familyName)
        }
        return FontRepresentable(
            descriptor: fontDesc,
            size: pointSize

        ) ?? self
#else
        fontDesc.withFamily(familyName)
        return FontRepresentable(descriptor: fontDesc, size: pointSize)
#endif
    }
}
