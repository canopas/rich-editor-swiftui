//
//  RichEditor.swift
//
//
//  Created by Divyesh Vekariya on 24/10/23.
//

import SwiftUI

public struct RichEditor: View {
    @ObservedObject var state: RichEditorState

    ///A Boolean value that indicates whether the text view is editable.
    var isEditable: Bool = true

    ///A Boolean value that determines whether user events are ignored and removed from the event queue.
    var isUserInteractionEnabled: Bool = true

    ///A Boolean value that determines whether scrolling is enabled.
    var isScrollEnabled: Bool = true

    ///The maximum number of lines that the text container can store.
    var linelimit: Int?

    ///The color of the text.
    var fontColor: Color? = nil

    ///The view’s background color.
    var backgroundColor:Color? = nil

    ///Add padding to all side of textContent
    var textPadding: CGFloat? = nil

    ///An integer that you can use to identify view objects in your application.
    var tag: Int? = nil

    public init(state: ObservedObject<RichEditorState>) {
        self._state = state
    }

    public var body: some View {
        TextViewWrapper(state: _state,
                        attributesToApply:  $state.attributesToApply,
                        isEditable: isEditable,
                        isUserInteractionEnabled: isUserInteractionEnabled,
                        isScrollEnabled: isScrollEnabled,
                        linelimit: linelimit,
                        fontStyle: state.currentFont,
                        fontColor: fontColor,
                        backGroundColor: backgroundColor,
                        tag: tag,
                        textPadding: textPadding,
                        onTextViewEvent: state.onTextViewEvent(_:))
    }
}
