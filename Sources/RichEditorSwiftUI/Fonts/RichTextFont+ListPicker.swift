//
//  RichTextFont+ListPicker.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/11/24.
//

import SwiftUI

public extension RichTextFont {

    /**
     This view uses a `List` to list a set of fonts of which
     one can be selected.

     Unlike ``RichTextFont/Picker`` this picker presents all
     pickers with proper previews on all platforms. You must
     therefore add it ina  way that gives it space.

     You can configure this picker by applying a config view
     modifier to your view hierarchy:

     ```swift
     VStack {
        RichTextFont.ListPicker(...)
        ...
     }
     .richTextFontPickerConfig(...)
     ```
     */
    struct ListPicker: View {

        /**
         Create a font list picker.

         - Parameters:
           - selection: The selected font name.
         */
        public init(
            selection: Binding<FontName>
        ) {
            self._selection = selection
        }

        public typealias Config = RichTextFont.PickerConfig
        public typealias Font = Config.Font
        public typealias FontName = Config.FontName

        @Binding
        private var selection: FontName

        @Environment(\.richTextFontPickerConfig)
        private var config

        public var body: some View {
            let font = Binding(
                get: { Font(fontName: selection) },
                set: { selection = $0.fontName }
            )

            RichEditorSwiftUI.ListPicker(
                items: config.fontsToList(for: selection),
                selection: font,
                dismissAfterPick: config.dismissAfterPick
            ) { font, isSelected in
                RichTextFont.PickerItem(
                    font: font,
                    fontSize: config.fontSize,
                    isSelected: isSelected
                )
            }
        }
    }
}
