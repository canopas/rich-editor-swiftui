//
//  ContentView.swift
//  RichEditorDemo
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI
import RichEditorSwiftUI

struct ContentView: View {
    @ObservedObject var state: RichEditorState = .init(input: false ? "" : "This is test text and it is too sort to see in the screen but it is fine to show smale string as it is easy to find bugs from small amout of code.")

    var body: some View {
        VStack {
            RichEditor(state: _state)
        }
        .padding()
    }
}
