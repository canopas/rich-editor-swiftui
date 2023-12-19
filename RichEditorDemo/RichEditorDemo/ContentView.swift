//
//  ContentView.swift
//  RichEditorDemo
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI
import RichEditorSwiftUI

struct ContentView: View {
    @ObservedObject var state: RichEditorState = .init(input: "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.")

    var body: some View {
        VStack {
            RichEditor(state: _state)
        }
        .padding()
    }
}
