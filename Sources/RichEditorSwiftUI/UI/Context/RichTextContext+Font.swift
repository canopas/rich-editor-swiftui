//
//  RichTextContext+Color.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/10/24.
//

import SwiftUI

extension RichEditorState {

  /// Get a binding for a certain FontName.
  public func bindingForFontName() -> Binding<String> {
    Binding(
      get: { self.getFontName() },
      set: { self.setFontName($0) }
    )
  }

  /// Get the value for a certain FontName.
  public func getFontName() -> String {
    return fontName
  }

  /// Set whether or not the context has a certain FontName style.
  public func setFontName(
    _ name: String
  ) {
    guard name != fontName else { return }
    updateStyle(style: .font(name))
  }
}
