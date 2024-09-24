//
//  RichEditor+Buildable.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 24/09/24.
//

import SwiftUI

extension RichEditor: Buildable {

    ///A Boolean value that indicates whether the text view is editable.
    public func isEditable(_ isEditable: Bool = true) -> Self {
        return mutating(keyPath: \.isEditable, value: isEditable)
    }

    ///A Boolean value that determines whether user events are ignored and removed from the event queue.
    public func isUserInteractionEnabled(_ enabled: Bool = true) -> Self {
        return mutating(keyPath: \.isUserInteractionEnabled, value: enabled)
    }

    ///A Boolean value that determines whether scrolling is enabled.
    public func isScrollEnabled(_ enabled: Bool = true) -> Self {
        return mutating(keyPath: \.isScrollEnabled, value: enabled)
    }

    ///The maximum number of lines that the text container can store.
    public func linelimit(_ linelimit: Int?) -> Self {
        return mutating(keyPath: \.linelimit, value: linelimit)
    }

    ///The color of the text.
    public func fontColor(_ color: Color? = nil) -> Self {
        return mutating(keyPath: \.fontColor, value: color)
    }

    ///The view’s background color.
    public func backgroundColor(_ color: Color? = nil) -> Self {
        return mutating(keyPath: \.backgroundColor, value: color)
    }

    ///Add padding to all side of textContent
    public func textPadding(_ padding: CGFloat? = nil) -> Self {
        return mutating(keyPath: \.textPadding, value: padding)
    }

    ///An integer that you can use to identify view objects in your application.
    public func tagId(_ tag: Int? = nil) -> Self {
        return mutating(keyPath: \.tag, value: tag)
    }
}
