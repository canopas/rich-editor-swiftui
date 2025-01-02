//
//  ImageAttachment.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 30/12/24.
//

import Foundation

public class ImageAttachment: Equatable {
  public static func == (lhs: ImageAttachment, rhs: ImageAttachment) -> Bool {
    return lhs.id == rhs.id && lhs.image == rhs.image
  }

  public let id: String
  public let image: ImageRepresentable
  internal var range: NSRange? = nil
  internal var url: String? = nil

  internal init(id: String? = nil, image: ImageRepresentable, range: NSRange, url: String? = nil) {
    self.id = id ?? UUID().uuidString
    self.image = image
    self.range = range
    self.url = url
  }

  public init(id: String? = nil, image: ImageRepresentable, url: String) {
    self.id = id ?? UUID().uuidString
    self.image = image
    self.url = url
  }

  public func updateUrl(with url: String) {
    self.url = url
  }

  internal func updateRange(with range: NSRange) {
    self.range = range
  }
}
