//
//  RichAttributes+ImageDownload.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 31/12/24.
//

import Foundation

extension RichAttributes {
  func getImage() async -> ImageRepresentable? {
    if let imageUrl = image {
      let image = try? await ImageDownloadManager.shared.fetchImage(from: imageUrl)
      return image
    }
    return nil
  }
}
