//
//  RichEditorState+Header.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/11/24.
//

import SwiftUI

public extension RichEditorState {

    /// Get a binding for a certain style.
    func headerBinding() -> Binding<HeaderType> {
        Binding(
            get: { self.currentHeader() },
            set: { self.setHeaderStyle($0) }
        )
    }

    /// Check whether or not the context has a certain header style.
    func currentHeader() -> HeaderType {
        return headerType
    }

    /// Set whether or not the context has a certain header style.
    func setHeaderStyle(
        _ header: HeaderType
    ) {
        guard header != headerType else { return }
        updateStyle(style: header.getTextSpanStyle())
    }

}

