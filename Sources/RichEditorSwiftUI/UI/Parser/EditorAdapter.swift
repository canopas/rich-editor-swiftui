//
//  EditorAdapter.swift
//
//
//  Created by Divyesh Vekariya on 11/12/23.
//

import Foundation

protocol EditorAdapter {
    func encode(input: String) -> RichText
    func decode(editorValue: RichText) -> String
}

class DefaultAdapter: EditorAdapter {
    func encode(input: String) -> RichText {
        return RichText(text: input)
    }
    
    func decode(editorValue: RichText) -> String {
        return editorValue.text
    }
}
