//
//  RichTextLabelValue.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 30/10/24.
//

import SwiftUI

/// This protocol can be implemented by any rich text values
/// that can be represented as a label.
public protocol RichTextLabelValue: Hashable {

    /// The value icon.
    var icon: Image { get }

    /// The value display title.
    var title: String { get }
}

public extension RichTextLabelValue {

    /// The standard label to use for the value.
    var label: some View {
        Label(
            title: { Text(title) },
            icon: { icon }
        )
        .tag(self)
    }
}
