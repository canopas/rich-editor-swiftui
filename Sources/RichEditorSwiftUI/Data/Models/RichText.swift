//
//  RichText.swift
//
//
//  Created by Divyesh Vekariya on 24/10/23.
//

import Foundation

public struct RichText: Codable {
    let text: String
    var spans: [RichTextSpan]
    
    init(text: String = "", spans: [RichTextSpan] = []) {
        self.text = text
        self.spans = spans
    }
}


