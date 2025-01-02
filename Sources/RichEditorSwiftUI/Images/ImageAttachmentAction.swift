//
//  ImageAttachmentAction.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 30/12/24.
//

import Foundation

public enum ImageAttachmentAction {
  case save([ImageAttachment])
  case delete([ImageAttachment])
  case getImage(ImageAttachment)
  case getImages([ImageAttachment])
}

public enum ImageAttachmentCompleteAction {
  case saved([ImageAttachment])
  case deleted
  case getImage(ImageAttachment?)
  case getImages([ImageAttachment])
}
