//
//  EditorAdapter.swift
//
//
//  Created by Divyesh Vekariya on 11/12/23.
//

import Foundation

protocol EditorAdapter {
    func encode(input: String, spans: [RichTextSpan]) -> RichText
    func decode(editorValue: RichText) -> String
}

class DefaultAdapter: EditorAdapter {
    func encode(input: String, spans: [RichTextSpan] = []) -> RichText {
        return RichText(text: input, spans: spans)
    }
    
    func decode(editorValue: RichText) -> String {
        return editorValue.text
    }
}
