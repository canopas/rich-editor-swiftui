//
//  RichTextWriter.swift
//
//
//  Created by Divyesh Vekariya on 28/12/23.
//

import Foundation

/**
 This protocol extends ``RichTextReader`` and is implemented
 by types that can provide a writable rich text string.
 
 This protocol is implemented by `NSMutableAttributedString`
 as well as other types in the library.
 */
public protocol RichTextWriter: RichTextReader {
    
    /// Get the writable attributed string for the type.
    var mutableAttributedString: NSMutableAttributedString? { get }
}

extension NSMutableAttributedString: RichTextWriter {
    
    /// This type returns itself as the attributed string.
    public var mutableAttributedString: NSMutableAttributedString? {
        self
    }
}

public extension RichTextWriter {
    
    /**
     Get the writable rich text provided by the implementing
     type.
     
     This is an alias for ``mutableAttributedString`` and is
     used to get a property that uses the rich text naming.
     */
    var mutableRichText: NSMutableAttributedString? {
        mutableAttributedString
    }
    
    /**
     Replace the text in a certain range with a new string.
     
     - Parameters:
     - range: The range to replace text in.
     - string: The string to replace the current text with.
     */
    func replaceText(in range: NSRange, with string: String) {
        mutableRichText?.replaceCharacters(in: range, with: string)
    }
    
    /**
     Replace the text in a certain range with a new string.
     
     - Parameters:
     - range: The range to replace text in.
     - string: The string to replace the current text with.
     */
    func replaceText(in range: NSRange, with string: NSAttributedString) {
        mutableRichText?.replaceCharacters(in: range, with: string)
    }
}

