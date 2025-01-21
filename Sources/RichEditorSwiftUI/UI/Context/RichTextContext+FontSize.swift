//
//  RichTextContext+Color.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/10/24.
//

import SwiftUI

extension RichEditorState {

  /// Get a binding for a certain FontSize.
  public func bindingForFontSize() -> Binding<CGFloat> {
    Binding(
      get: { self.getFontSize() },
      set: { self.setFontSize($0) }
    )
  }

  /// Get the value for a certain FontSize.
  public func getFontSize() -> CGFloat {
    return fontSize
  }

  /// Set whether or not the context has a certain FontSize style.
  public func setFontSize(
    _ size: CGFloat
  ) {
    guard size != fontSize else { return }
    updateStyle(style: .size(Int(size)))
  }
}
