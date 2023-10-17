//
//  EditorAttribute.swift
//
//
//  Created by Divyesh Vekariya on 12/10/23.
//

import Foundation

typealias EditorAttribute = [EditorAttributeElement]

class EditorAttributeElement: Codable {
    let id: String
    let type: String
    let content: Content?
    let url: String?
    
    init(id: String = UUID().uuidString, type: String, content: Content?, url: String?) {
        self.id = id
        self.type = type
        self.content = content
        self.url = url
    }
}

// MARK: - Content
class Content: Codable {
    let text: String
    let spans: [Span]
    
    init(text: String, spans: [Span]) {
        self.text = text
        self.spans = spans
    }
}

// MARK: - Span
class Span: Codable {
    let from, to: Int
    let style: String
    
    init(from: Int, to: Int, style: String) {
        self.from = from
        self.to = to
        self.style = style
    }
}
