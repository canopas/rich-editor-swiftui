//
//  File.swift
//  
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import Foundation

public enum EditorTool: CaseIterable {
    case title
    case bold
    case italic
    case underline
    case photo
    case video
    
    public var systemName: String {
        switch self {
        case .title:
            return "textformat.alt"
        case .bold:
            return "bold"
        case .italic:
            return "italic"
        case .underline:
            return "underline"
        case .photo:
            return "photo"
        case .video:
            return "video"
        }
    }
    
    public var isContainManu: Bool {
        switch self {
        case .title:
            return true
        default:
            return false
        }
    }
}
