//
//  RichEditorState+Header.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/11/24.
//

import SwiftUI

extension RichEditorState {

    /// Get a binding for a certain style.
    public func headerBinding() -> Binding<HeaderType> {
        Binding(
            get: { self.currentHeader() },
            set: { self.setHeaderStyle($0) }
        )
    }

    /// Check whether or not the context has a certain header style.
    public func currentHeader() -> HeaderType {
        return headerType
    }

    /// Set whether or not the context has a certain header style.
    public func setHeaderStyle(
        _ header: HeaderType
    ) {
        guard header != headerType else { return }
        updateStyle(style: header.getTextSpanStyle())
    }

}
