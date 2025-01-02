//
//  ImageFileManager.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 30/12/24.
//

import CryptoKit
import Foundation

class ImageFileManager {

  static let shared = ImageFileManager()

  private let fileManager = FileManager.default
  private let imagesDirectory: URL

  private init() {
    // Define a directory for storing images.
    let directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    imagesDirectory = directory.appendingPathComponent("Images")

    // Create the directory if it doesn't exist.
    if !fileManager.fileExists(atPath: imagesDirectory.path) {
      try? fileManager.createDirectory(
        at: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
    }
  }

  /// Saves an image to the filesystem if it is not already stored.
  /// - Parameters:
  ///   - image: The image to save.
  ///   - fileName: The name of the file (without extension).
  ///   - compressionQuality: Compression quality for JPEG (0.0 - 1.0).
  /// - Returns: The file name of the stored image.
  func saveImage(_ image: ImageRepresentable, fileName: String, compressionQuality: CGFloat = 1.0)
    throws -> String
  {
    let imageHash = try hashImage(image)
    let uniqueFileName = "\(fileName)_\(imageHash).jpg"
    let fileURL = imagesDirectory.appendingPathComponent(uniqueFileName)

    if fileManager.fileExists(atPath: fileURL.path) {
      return uniqueFileName  // Image already exists; return its file name.
    }

    #if canImport(AppKit)
      guard let data = image.jpegData(compressionQuality: compressionQuality) else {
        throw NSError(
          domain: "ImageFileManager", code: 500,
          userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data."])
      }
    #elseif canImport(UIKit)
      guard let data = image.jpegData(compressionQuality: compressionQuality) else {
        throw NSError(
          domain: "ImageFileManager", code: 500,
          userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data."])
      }
    #endif

    try data.write(to: fileURL)
    return uniqueFileName
  }

  /// Retrieves an image from the filesystem.
  /// - Parameter fileName: The name of the file (without extension).
  /// - Returns: The retrieved image or nil if not found.
  func loadImage(fileName: String) -> ImageRepresentable? {
    let fileURL = imagesDirectory.appendingPathComponent(fileName)

    #if canImport(AppKit)
      return ImageRepresentable(contentsOfFile: fileURL.path)
    #elseif canImport(UIKit)
      return ImageRepresentable(contentsOfFile: fileURL.path)
    #endif
  }

  /// Deletes an image from the filesystem.
  /// - Parameter fileName: The name of the file (without extension).
  func deleteImage(fileName: String) throws {
    let fileURL = imagesDirectory.appendingPathComponent(fileName)
    try fileManager.removeItem(at: fileURL)
  }

  /// Checks if an image exists in the filesystem.
  /// - Parameter fileName: The name of the file (without extension).
  /// - Returns: `true` if the image exists, otherwise `false`.
  func imageExists(fileName: String) -> Bool {
    let fileURL = imagesDirectory.appendingPathComponent(fileName)
    return fileManager.fileExists(atPath: fileURL.path)
  }

  /// Computes a unique hash for an image.
  /// - Parameter image: The image to hash.
  /// - Returns: A string representing the hash of the image.
  private func hashImage(_ image: ImageRepresentable) throws -> String {
    #if canImport(AppKit)
      guard let data = image.tiffRepresentation else {
        throw NSError(
          domain: "ImageFileManager", code: 500,
          userInfo: [NSLocalizedDescriptionKey: "Failed to get TIFF data for image."])
      }
    #elseif canImport(UIKit)
      guard let data = image.pngData() else {
        throw NSError(
          domain: "ImageFileManager", code: 500,
          userInfo: [NSLocalizedDescriptionKey: "Failed to get PNG data for image."])
      }
    #endif

    let hash = SHA256.hash(data: data)
    return hash.map { String(format: "%02x", $0) }.joined()
  }
}
