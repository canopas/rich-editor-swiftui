//
//  RichText.swift
//
//
//  Created by Divyesh Vekariya on 12/02/24.
//

import Foundation

typealias RichTextSpans = [RichTextSpan]

public struct RichText: Codable {
  public let spans: [RichTextSpan]

  public init(spans: [RichTextSpan] = []) {
    self.spans = spans
  }

  func encodeToData() throws -> Data {
    return try JSONEncoder().encode(self)
  }
}

public struct RichTextSpan: Codable {
  //    public var id: String = UUID().uuidString
  public let insert: String
  public let attributes: RichAttributes?

  public init(
    insert: String,
    attributes: RichAttributes? = nil
  ) {
    //        self.id = id
    self.insert = insert
    self.attributes = attributes
  }
}

extension RichTextSpan {

  // Custom Encoding
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    // If there is an image in the attributes, encode insert as an image object
    if let image = attributes?.image {
      let richTextImage = RichTextImage(image: image)
      try container.encode(richTextImage, forKey: .insert)
    } else {
      // Otherwise, just encode insert as a simple string
      try container.encode(insert, forKey: .insert)
    }

    try container.encodeIfPresent(attributes, forKey: .attributes)
  }

  // Custom Decoding
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    var imageAttribute: String? = nil
    // Decode insert as a string and extract image form json's insert if available
    if let imageDict = try? container.decode([String: String].self, forKey: .insert),
      let image = imageDict["image"]
    {
      self.insert = " "
      // If insert contains an image, set insert to the image URL and set the image attribute
      imageAttribute = image
    } else {
      // If insert is just a string, set insert as usual
      self.insert = try container.decode(String.self, forKey: .insert)
    }
    let attributesInit = try container.decodeIfPresent(RichAttributes.self, forKey: .attributes)
    self.attributes = attributesInit?.copy(with: .image(imageAttribute), byAdding: true)

  }

  enum CodingKeys: String, CodingKey {
    case insert
    case attributes
  }
}

internal struct RichTextImage: Codable {
  let image: String

  enum CodingKeys: String, CodingKey {
    case image = "image"
  }

  init(image: String) {
    self.image = image
  }
}
