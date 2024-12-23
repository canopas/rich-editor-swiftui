//
//  RichTextFont+SizePicker.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/10/24.
//

import SwiftUI

extension RichTextFont {

    /**
     This picker can be used to pick a font size.

     The view returns a plain SwiftUI `Picker` view that can
     be styled and configured with plain SwiftUI.

     You can configure this picker by applying a config view
     modifier to your view hierarchy:

     ```swift
     VStack {
     RichTextFont.SizePicker(...)
     ...
     }
     .richTextFontSizePickerConfig(...)
     ```
     */
    public struct SizePicker: View {

        /**
         Create a font size picker.

         - Parameters:
         - selection: The selected font size.
         */
        public init(
            selection: Binding<CGFloat>
        ) {
            self._selection = selection
        }

        @Binding
        private var selection: CGFloat

        @Environment(\.richTextFontSizePickerConfig)
        private var config

        public var body: some View {
            SwiftUI.Picker("", selection: $selection) {
                ForEach(
                    values(
                        for: config.values,
                        selection: selection
                    ), id: \.self
                ) {
                    text(for: $0)
                        .tag($0)
                }
            }
        }
    }
}

extension RichTextFont.SizePicker {

    /// Get a list of values for a certain selection.
    public func values(
        for values: [CGFloat],
        selection: CGFloat
    ) -> [CGFloat] {
        let values = values + [selection]
        return Array(Set(values)).sorted()
    }
}

extension RichTextFont.SizePicker {

    fileprivate func text(
        for fontSize: CGFloat
    ) -> some View {
        Text("\(Int(fontSize))")
            .fixedSize(horizontal: true, vertical: false)
    }
}
