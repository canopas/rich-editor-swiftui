//
//  StandardRichTextExportService.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import Foundation

/**
 This export service can be used to export rich text content
 to files with a certain format.

 Files are by default written to the app document folder. It
 can be changed by providing another searchpath directory in
 the initializer.
 */
public class StandardRichTextExportService: RichTextExportService {
    

    /**
     Create a standard rich text export service.

     - Parameters:
       - urlResolver: The type to use to resolve file urls, by default `FileManager.default`.
       - directory: The directory to save the file in, by default `.documentDirectory`.
     */
    public init(
        urlResolver: RichTextExportUrlResolver = FileManager.default,
        directory: FileManager.SearchPathDirectory = .documentDirectory
    ) {
        self.urlResolver = urlResolver
        self.directory = directory
    }

    private let urlResolver: RichTextExportUrlResolver
    private let directory: FileManager.SearchPathDirectory

    /**
     Generate a file with a certain name, content and format.

     Exported files will by default be exported to the app's
     document folder, which means that we should give them a
     unique name to avoid overwriting already existing files.

     To achieve this, we'll use the `uniqueFileUrl` function
     of the url resolver, which by default will add a suffix
     until the file name no longer exists.

     - Parameters:
       - fileName: The preferred name of the exported name.
       - content: The rich text content to export.
       - format: The rich text format to use when exporting.
     */
    public func generateExportFile(
        withName fileName: String,
        content: NSAttributedString,
        format: RichTextDataFormat
    ) throws -> URL {
        let fileUrl = try urlResolver.uniqueFileUrl(
            withName: fileName,
            extension: format.standardFileExtension,
            in: directory)
        let data = try content.richTextData(for: format)
        try data.write(to: fileUrl)
        return fileUrl
    }

    /**
     Generate a PDF file with a certain name and content.

     Exported files will by default be exported to the app's
     document folder, which means that we should give them a
     unique name to avoid overwriting already existing files.

     To achieve this, we'll use the `uniqueFileUrl` function
     of the url resolver, which by default will add a suffix
     until the file name no longer exists.

     - Parameters:
       - fileName: The preferred file name.
       - content: The rich text content to export.
     */
    public func generatePdfExportFile(
        withName fileName: String,
        content: NSAttributedString
    ) throws -> URL {
        let fileUrl = try urlResolver.uniqueFileUrl(
            withName: fileName,
            extension: "pdf",
            in: directory)
        let data = try content.richTextPdfData()
        try data.write(to: fileUrl)
        return fileUrl
    }

    /**
     Generate a JSON file with a certain name and content.

     Exported files will by default be exported to the app's
     document folder, which means that we should give them a
     unique name to avoid overwriting already existing files.

     To achieve this, we'll use the `uniqueFileUrl` function
     of the url resolver, which by default will add a suffix
     until the file name no longer exists.

     - Parameters:
     - fileName: The preferred file name.
     - content: The rich text content to export.
     */
    public func generateJsonExportFile(
        withName fileName: String,
        content: RichText
    ) throws -> URL {
        let fileUrl = try urlResolver.uniqueFileUrl(
            withName: fileName,
            extension: "json",
            in: directory)
        let data = try content.encodeToData()
        try data.write(to: fileUrl)
        return fileUrl
    }

    /**
     Get `Data` for with provided `RichTextDataFormat`
     */
    public func getDataFor(_ string: NSAttributedString, format: RichTextDataFormat) throws -> Data {
        return try string.richTextData(for: format)
    }

    /**
     Get `Data` for `PDF` format.
     */
    public func getDataForPdfFormat(_ string: NSAttributedString) throws -> Data {
        return try string.richTextPdfData()
    }

    /**
     Get `Data` for `JSON` format.
     */
    public func getDataForJsonFormat(_ richText: RichText) throws -> Data {
        return try richText.encodeToData()
    }
}
