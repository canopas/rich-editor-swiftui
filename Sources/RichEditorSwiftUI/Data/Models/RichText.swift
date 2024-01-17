//
//  RichText.swift
//
//
//  Created by Divyesh Vekariya on 24/10/23.
//

import Foundation

public struct RichText: Codable {
    public let text: String
    public let spans: [RichTextSpan]
    
    public init(text: String = "", spans: [RichTextSpan] = []) {
        self.text = text
        self.spans = spans
    }
}


