//
//  RichTextHeader+Picker.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 25/11/24.
//

import SwiftUI

public extension RichTextHeader {

    /**
     This picker can be used to pick a Header type.

     The view returns a plain SwiftUI `Picker` view that can
     be styled and configured with plain SwiftUI.

     You can configure this picker by applying a config view
     modifier to your view hierarchy:

     ```swift
     VStack {
     RichTextHeader.HeaderTypePicker(...)
     ...
     }
     ```
     */
    struct Picker: View {

        /**
         Create a font size picker.

         - Parameters:
         - selection: The selected font size.
         */
        public init(
            context: RichEditorState,
            values: [HeaderType]
        ) {
            self._selection = context.headerBinding()
            self.values = values
        }

        @Binding
        private var selection: HeaderType

        private let values: [HeaderType]

        public var body: some View {
            SwiftUI.Picker("", selection: $selection) {
                ForEach(values,
                        id: \.self) {
                    text(for: $0)
                        .tag($0)
                }
            }
        }
    }
}

private extension RichTextHeader.Picker {

    func text(
        for headerType: HeaderType
    ) -> some View {
        Text(headerType.titleLabel)
            .fixedSize(horizontal: true, vertical: false)
    }
}

