//
//  ListPickerItem.swift
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
protocol ListPickerItem: View {

    associatedtype Item: Equatable

    var item: Item { get }
    var isSelected: Bool { get }
}

extension ListPickerItem {

    var checkmark: some View {
        Image(systemName: "checkmark")
            .opacity(isSelected ? 1 : 0)
    }
}
