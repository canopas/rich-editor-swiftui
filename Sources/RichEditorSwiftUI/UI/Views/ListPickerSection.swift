//
//  ListPickerSection.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/11/24.
//

import SwiftUI

/**
 This is an internal version of the original that is defined
 and available in https://github.com/danielsaidi/swiftuikit.
 This will not be made public or documented for this library.
 */
struct ListPickerSection<Item: Identifiable>: Identifiable {

    init(title: String, items: [Item]) {
        self.id = UUID()
        self.title = title
        self.items = items
    }

    let id: UUID
    let title: String
    let items: [Item]

    @ViewBuilder
    var header: some View {
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            EmptyView()
        } else {
            Text(title)
        }
    }
}
