//
//  RichTextExportError.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import Foundation

/**
 This enum defines errors that can be thrown when failing to
 export rich text.
 */
public enum RichTextExportError: Error {

    /// This error occurs when no file could be generated at a certain url.
    case cantCreateFile(at: URL)

    /// This error occurs when no file could be generated in a certain directory.
    case cantCreateFileUrl(in: FileManager.SearchPathDirectory)
}
