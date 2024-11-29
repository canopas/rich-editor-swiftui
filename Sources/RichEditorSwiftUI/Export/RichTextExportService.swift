//
//  RichTextExportService.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import Foundation

/**
 This protocol can be implemented by any classes that can be
 used to export rich text to files.
 */
@preconcurrency @MainActor
public protocol RichTextExportService: AnyObject {

    /**
     Generate an export file with a certain name and content,
     that uses a certain rich text data format.

     - Parameters:
       - fileName: The preferred file name.
       - content: The rich text content to export.
       - format: The rich text format to use when exporting.
     */
    func generateExportFile(
        withName fileName: String,
        content: NSAttributedString,
        format: RichTextDataFormat
    ) throws -> URL

    /**
     Generate a PDF export file with a certain name and rich
     text content.

     - Parameters:
       - fileName: The preferred file name.
       - content: The rich text content to export.
     */
    func generatePdfExportFile(
        withName fileName: String,
        content: NSAttributedString
    ) throws -> URL

    /**
     Generate a JSON export file with a certain name and rich
     text content.

     - Parameters:
     - fileName: The preferred file name.
     - content: The rich text (`RichText`) content to export.
     */
    func generateJsonExportFile(
        withName fileName: String,
        content: RichText
    ) throws -> URL

    /**
     Get `Data` for with provided `RichTextDataFormat`
     */
    func getDataFor(_ string: NSAttributedString, format: RichTextDataFormat) throws -> Data

    /**
     Get `Data` for `PDF` format.
     */
    func getDataForPdfFormat(_ string: NSAttributedString) throws -> Data
    /**
     Get `Data` for `JSON` format.
     */
    func getDataForJsonFormat(_ richText: RichText) throws -> Data
}
