//
//  RichTextDataFormat+Menu.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextDataFormat {

    /**
     This menu can be used to trigger custom actions for any
     list of ``RichTextDataFormat`` values.

     The menu uses customizable actions, which means that it
     can be used in toolbars, menu bar commands etc. It also
     has an optional `pdf` action, which for instance can be
     used when exporting or sharing rich text.
     */
    struct Menu: View {

        public init(
            title: String,
            icon: Image,
            formats: [Format] = Format.libraryFormats,
            otherFormats: [RichTextExportOption] = .all,
            formatAction: @escaping (Format) -> Void,
            otherOptionAction: ((RichTextExportOption) -> Void)? = nil
        ) {
            self.title = title
            self.icon = icon
            self.formats = formats
            self.otherFormats = otherFormats
            self.formatAction = formatAction
            self.otherOptionAction = otherOptionAction
        }

        public typealias Format = RichTextDataFormat

        private let title: String
        private let icon: Image
        private let formats: [Format]
        private let otherFormats: [RichTextExportOption]
        private let formatAction: (Format) -> Void
        private let otherOptionAction: ((RichTextExportOption) -> Void)?

        public var body: some View {
            SwiftUI.Menu {
                ForEach(formats) { format in
                    Button {
                        formatAction(format)
                    } label: {
                        icon.label(format.fileFormatText)
                    }
                }
                if let action = otherOptionAction {
                    ForEach(otherFormats) { format in
                        Button {
                            action(format)
                        } label: {
                            icon.label(format.fileFormatText)
                        }
                    }
                }
            } label: {
                icon.label(title)
            }
        }
    }
}
#endif
