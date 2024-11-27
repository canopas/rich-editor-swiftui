//
//  RichTextDataError.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import Foundation

/**
 This enum represents rich text data-related errors.
 */
public enum RichTextDataError: Error {

    case invalidArchivedData(in: Data)
    case invalidPlainTextData(in: Data)
    case invalidData(in: String)
}
