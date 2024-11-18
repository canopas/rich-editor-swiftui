//
//  Image+Label.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/10/24.
//

import SwiftUI

extension Image {

    /// Create a label from the icon.
    func label(_ title: String) -> some View {
        Label {
            Text(title)
        } icon: {
            self
        }
    }
}
