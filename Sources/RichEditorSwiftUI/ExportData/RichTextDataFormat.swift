//
//  RichTextData+Format.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import Foundation
import UniformTypeIdentifiers

/// This enum specifies rich text data formats.
///
/// Different formats have different capabilities. For instance,
/// ``rtf`` supports rich text, styles, etc., while ``plainText``
/// only handles text. ``archivedData`` can archive text, image
/// data and attachments in binary archives. This is convenient
/// when only targeting Apple platforms, but restricts how data
/// can be used elsewhere.
///
/// ``archivedData`` uses an `rtk` file extension, as well as a
/// `UTType.archivedData` uniform type. You can create a custom
/// ``vendorArchivedData(id:fileExtension:fileFormatText:uniformType:)``
/// value to specify a custom data format.
///
/// Remember to configure your app for handling the UTTypes you
/// want to support, as well as the file extensions you want to
/// open with the app. Take a look at the demo app for examples.
public enum RichTextDataFormat: Equatable, Identifiable {

    /// Archived data that's persisted with a keyed archiver.
    case archivedData

    /// Plain data is persisted as plain text.
    case plainText

    /// RTF data is persisted as formatted text.
    case rtf

    /// A vendor-specific archived data format.
    case vendorArchivedData(
        id: String,
        fileExtension: String,
        fileFormatText: String,
        uniformType: UTType
    )
}

extension Collection where Element == RichTextDataFormat {

    /// Get all library supported data formats.
    public static var libraryFormats: [Element] {
        Element.libraryFormats
    }
}

extension RichTextDataFormat {

    /// Get all library supported data formats.
    public static var libraryFormats: [Self] {
        [.archivedData, .plainText, .rtf]
    }

    /// The format's unique identifier.
    public var id: String {
        switch self {
        case .archivedData: "archivedData"
        case .plainText: "plainText"
        case .rtf: "rtf"
        case .vendorArchivedData(let id, _, _, _): id
        }
    }

    /// The formats that a format can be converted to.
    public var convertibleFormats: [Self] {
        switch self {
        case .vendorArchivedData: Self.libraryFormats.removing(.archivedData)
        default: Self.libraryFormats.removing(self)
        }
    }

    /// The format's file format display text.
    public var fileFormatText: String {
        switch self {
        case .archivedData: RTEL10n.fileFormatRtk.text
        case .plainText: RTEL10n.fileFormatTxt.text
        case .rtf: RTEL10n.fileFormatRtf.text
        case .vendorArchivedData(_, _, let text, _): text
        }
    }

    /// Whether or not the format is an archived data type.
    public var isArchivedDataFormat: Bool {
        switch self {
        case .archivedData: true
        case .plainText: false
        case .rtf: false
        case .vendorArchivedData: true
        }
    }

    /// The format's standard file extension.
    public var standardFileExtension: String {
        switch self {
        case .archivedData: "rtk"
        case .plainText: "txt"
        case .rtf: "rtf"
        case .vendorArchivedData(_, let ext, _, _): ext
        }
    }

    /// Whether or not the format supports images.
    public var supportsImages: Bool {
        switch self {
        case .archivedData: true
        case .plainText: false
        case .rtf: false
        case .vendorArchivedData: true
        }
    }

    /// The format's uniform type.
    public var uniformType: UTType {
        switch self {
        case .archivedData: .archivedData
        case .plainText: .plainText
        case .rtf: .rtf
        case .vendorArchivedData(_, _, _, let type): type
        }
    }
}

extension Collection where Element == RichTextDataFormat {

    fileprivate func removing(_ format: Element) -> [Element] {
        filter { $0 != format }
    }
}
