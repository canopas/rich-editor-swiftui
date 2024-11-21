//
//  ListPicker.swift
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
struct ListPicker<Item: Identifiable, ItemView: View>: View {

    init(
        items: [Item],
        selection: Binding<Item>,
        animatedSelection: Bool = false,
        dismissAfterPick: Bool = true,
        listItem: @escaping ItemViewBuilder
    ) {
        self.init(
            sections: [ListPickerSection(title: "", items: items)],
            selection: selection,
            animatedSelection: animatedSelection,
            dismissAfterPick: dismissAfterPick,
            listItem: listItem)
    }

    init(
        sections: [ListPickerSection<Item>],
        selection: Binding<Item>,
        animatedSelection: Bool = false,
        dismissAfterPick: Bool = true,
        listItem: @escaping ItemViewBuilder
    ) {
        self.sections = sections
        self.selection = selection
        self.animatedSelection = animatedSelection
        self.dismissAfterPick = dismissAfterPick
        self.listItem = listItem
    }

    private let sections: [ListPickerSection<Item>]
    private let selection: Binding<Item>
    private let animatedSelection: Bool
    private let dismissAfterPick: Bool
    private let listItem: ItemViewBuilder

    typealias ItemViewBuilder = (_ item: Item, _ isSelected: Bool) -> ItemView

    var body: some View {
        List {
            ForEach(sections) { section in
                Section(header: section.header) {
                    ForEachPicker(
                        items: section.items,
                        selection: selection,
                        animatedSelection: animatedSelection,
                        dismissAfterPick: dismissAfterPick,
                        listItem: listItem
                    )
                }
            }
        }
    }
}
