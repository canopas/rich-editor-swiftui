//
//  RichEditorState+LineInfo.swift
//
//
//  Created by Divyesh Vekariya on 31/05/24.
//

import Foundation


extension RichEditorState {

    internal struct LineInfo {
        let lineNumber: Int
        let lineRange: NSRange
        let lineString: String
        let caretLocation: Int
    }

    /**
     Calculates which line number (using a 0 based index) our caret is on, the range of this line (in comparison to the whole string), and the string that makes up that line of text.
     Will return nil if there is no caret present, and a portion of text is highlighted instead.

     A pain point of this function is that it cannot return the current line number when it's found, but rather
     has to wait for every single line to be iterated through first. This is because the enumerateSubstrings() function
     on the String is not an actual loop, and as such we cannot return or break within it.

     - returns: The line number that the caret is on, the range of our line, and the string that makes up that line of text
     */
    var currentLine: LineInfo {
        return getCurrentLineInfo(rawText, selectedRange: highlightedRange)
    }

    internal func getCurrentLineInfo(_ string: String, selectedRange: NSRange) -> LineInfo {

        /// Determines if the user has selected (ie. highlighted) any text
        var hasSelectedText: Bool {
            !selectedRange.isCollapsed
        }

        /// The location of our caret within the textview
        var caretLocation: Int {
            selectedRange.location
        }


        //The line number that we're currently iterating on
        var lineNumber = 0

        //The line number & line of text that we believe the caret to be on
        var selectedLineNumber = 0
        var selectedLineRange  = selectedRange
        var selectedLineOfText = ""
        var caretLocationInLine = 0

        var foundSelectedLine = false

        //Iterate over every line in our TextView
        string.enumerateSubstrings(in: string.startIndex..<string.endIndex, options: .byLines) {(substring, substringRange, _, _) in
            //The range of this current line
            let range = NSRange(substringRange, in: string)

            //Calculate the start location of our line and the end location of our line, in context to our TextView.string as a whole
            let startOfLine = range.location
            let endOfLine   = range.location + range.length

            //If the CaretLocation is between the start of this line, and the end of this line, we can assume that the caret is on this line
            if caretLocation >= startOfLine && caretLocation <= endOfLine {
                // MARK the line number
                selectedLineNumber = lineNumber
                selectedLineOfText = substring ?? ""
                selectedLineRange  = range
                caretLocationInLine = caretLocation - startOfLine

                foundSelectedLine = true
            }

            lineNumber += 1
        }

        //If we're not at the starting point, and we didn't find a current line, then we're at the end of our TextView
        if caretLocation > 0 && !foundSelectedLine {
            selectedLineNumber = lineNumber
            selectedLineOfText = ""
            selectedLineRange  = NSRange(location: caretLocation, length: 0)
        }
        return LineInfo(lineNumber: selectedLineNumber, lineRange: selectedLineRange, lineString: selectedLineOfText, caretLocation: caretLocationInLine)
    }
}
