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
        NavigationStack {
            VStack {
                RichEditor(state: _state)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        let spans = state.richText.spans
                        print("==== spans are \(spans.map({ ($0.from, $0.to, $0.style.rawValue) }))")
                    }, label: {
                        Text("Save")
                            .padding()
                    })
                }
            }
            .navigationTitle("Rich Editor")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
