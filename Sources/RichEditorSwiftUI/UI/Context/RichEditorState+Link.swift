//
//  RichEditorState+Link.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 19/12/24.
//

import SwiftUI

#if os(iOS) || os(tvOS) || os(macOS) || os(visionOS)
  extension RichEditorState {
    func insertLink(value: Bool) {
      if link != nil {
        alertController.showAlert(
          title: "Remove link", message: "It will remove link from selected text",
          onOk: { [weak self] in
            guard let self else { return }
            self.updateStyle(style: .link())
          },
          onCancel: {
            return
          })
      } else {
        alertController.showAlert(
          title: "Enter url", message: "", placeholder: "Enter link",
          defaultText: "",
          onTextChange: { text in
          },
          completion: { [weak self] finalText in
            self?.updateStyle(style: .link(finalText))
          })
      }
    }
  }

  extension RichEditorState {

    /// Get a binding for a certain style.
    public func bindingForManu(for menu: RichTextOtherMenu) -> Binding<Bool> {
      Binding(
        get: { Bool(self.hasStyle(menu)) },
        set: { self.setLink(to: $0) }
      )
    }

    /// Check whether or not the context has a certain style.
    public func hasStyle(_ style: RichTextOtherMenu) -> Bool {
      link != nil
    }

    /// Set whether or not the context has a certain style.
    public func setLink(
      to val: Bool
    ) {
      insertLink(value: val)
    }
  }
#endif
