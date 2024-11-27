//
//  RichTextExportOption.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 27/11/24.
//

import Foundation

public enum RichTextExportOption: CaseIterable, Equatable, Identifiable {
    case pdf
    case json
}

public extension RichTextExportOption {
    /// The format's unique identifier.
    var id: String {
        switch self {
        case .pdf: "pdf"
        case .json: "json"
        }
    }

    /// The format's file format display text.
    var fileFormatText: String {
        switch self {
        case .pdf: RTEL10n.fileFormatPdf.text
        case .json: RTEL10n.fileFormatJson.text
        }
    }
}

public extension Collection where Element == RichTextExportOption {

    static var all: [Element] { RichTextExportOption.allCases }
}
