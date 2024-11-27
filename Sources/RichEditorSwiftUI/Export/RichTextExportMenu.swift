//
//  RichTextExportMenu.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/**
 This menu can be used to trigger various export actions for
 a list of ``RichTextDataFormat`` values.

 This menu uses a ``RichTextDataFormat/Menu`` configured for
 exporting, with customizable actions and data formats.
 */
public struct RichTextExportMenu: View {

    public init(
        title: String = RTEL10n.menuExportAs.text,
        icon: Image = .richTextExport,
        formats: [RichTextDataFormat] = RichTextDataFormat.libraryFormats,
        otherFormats: [RichTextExportOption] = .all,
        formatAction: @escaping (RichTextDataFormat) -> Void,
        otherOptionAction: ((RichTextExportOption) -> Void)? = nil
    ) {
        self.menu = RichTextDataFormat.Menu(
            title: title,
            icon: icon,
            formats: formats,
            otherFormats: otherFormats,
            formatAction: formatAction,
            otherOptionAction: otherOptionAction
        )
    }

    private let menu: RichTextDataFormat.Menu

    public var body: some View {
        menu
    }
}
#endif
