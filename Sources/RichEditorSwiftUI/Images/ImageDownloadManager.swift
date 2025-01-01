//
//  ImageDownloadManager.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 30/12/24.
//

import Foundation

public class ImageDownloadManager {

  static let shared = ImageDownloadManager()

  private init() {}

  /// Fetches an image from a URL, which can be a local file path or a remote URL.
  /// - Parameter urlString: The URL string of the image.
  /// - Returns: An `ImageRepresentable` instance or throws an error.
  func fetchImage(from urlString: String) async throws -> ImageRepresentable {
    if FileManager.default.fileExists(atPath: urlString) {
      return try await fetchImageFromLocalPath(urlString)
    } else {
      return try await fetchImageFromRemoteURL(urlString)
    }
  }

  /// Fetches an image from a local file path.
  private func fetchImageFromLocalPath(_ path: String) async throws -> ImageRepresentable {
    return try await withCheckedThrowingContinuation { continuation in
      #if canImport(AppKit)
        if let image = ImageRepresentable(contentsOfFile: path) {
          continuation.resume(returning: image)
        } else {
          continuation.resume(
            throwing: NSError(
              domain: "ImageDownloadManager", code: 404,
              userInfo: [NSLocalizedDescriptionKey: "Image not found at path: \(path)"]))
        }
      #elseif canImport(UIKit)
        if let image = ImageRepresentable(contentsOfFile: path) {
          continuation.resume(returning: image)
        } else {
          continuation.resume(
            throwing: NSError(
              domain: "ImageDownloadManager", code: 404,
              userInfo: [NSLocalizedDescriptionKey: "Image not found at path: \(path)"]))
        }
      #endif
    }
  }

  /// Fetches an image from a remote URL.
  private func fetchImageFromRemoteURL(_ urlString: String) async throws -> ImageRepresentable {
    guard let url = URL(string: urlString) else {
      throw NSError(
        domain: "ImageDownloadManager", code: 400,
        userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
    }

    let (data, response) = try await URLSession.shared.data(from: url)
    guard let image = ImageRepresentable(data: data) else {
      throw NSError(
        domain: "ImageDownloadManager", code: 500,
        userInfo: [NSLocalizedDescriptionKey: "Failed to decode image"])
    }

    return image
  }
}
