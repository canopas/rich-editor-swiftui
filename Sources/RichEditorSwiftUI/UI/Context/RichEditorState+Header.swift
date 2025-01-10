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
      set: { self.setStyle($0) }
    )
  }

  /// Check whether or not the context has a certain header style.
  public func currentHeader() -> HeaderType {
    return headerType
  }

  /// Set whether or not the context has a certain header style.
  public func setStyle(
    _ header: HeaderType
  ) {
    updateStyle(style: header.getTextSpanStyle())
  }

  /// Set whether or not the context has a certain header style.
  public func setHeaderStyle(
    _ header: HeaderType
  ) {
    actionPublisher.send(.setHeaderStyle(header.getTextSpanStyle()))
    setHeaderInternal(header: header)
  }

  private func setHeaderInternal(
    header: HeaderType
  ) {
    guard header != headerType else { return }
    headerType = header
  }
}
