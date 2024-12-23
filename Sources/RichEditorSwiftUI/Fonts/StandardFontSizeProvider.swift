//
// StandardFontSizeProvider.swift
//
//
//  Created by Divyesh Vekariya on 12/01/24.
//

import Foundation

public protocol StandardFontSizeProvider {}

extension CGFloat: StandardFontSizeProvider {}

extension Double: StandardFontSizeProvider {}

extension RichEditorState: StandardFontSizeProvider {}

#if os(iOS) || os(macOS) || os(tvOS)
    extension RichTextEditor: StandardFontSizeProvider {}

    extension RichTextView: StandardFontSizeProvider {}
#endif

extension StandardFontSizeProvider {

    /**
     The standard font size to use for rich text.

     You can change this value to affect all types that make
     use of this value.
     */
    public static var standardRichTextFontSize: CGFloat {
        get { StandardFontSizeProviderStorage.standardRichTextFontSize }
        set {
            StandardFontSizeProviderStorage.standardRichTextFontSize = newValue
        }
    }
}

private class StandardFontSizeProviderStorage {

    static var standardRichTextFontSize: CGFloat = 16
}
