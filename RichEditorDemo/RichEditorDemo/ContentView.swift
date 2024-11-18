//
//  ContentView.swift
//  RichEditorDemo
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI
import RichEditorSwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var state: RichEditorState

    init(state: RichEditorState? = nil) {
        if let state {
            self.state = state
        } else {
            if let richText = readJSONFromFile(fileName: "Sample_json",
                                               type: RichText.self) {
                self.state = .init(richText: richText)
            } else {
                self.state = .init(input: "Hello World!")
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
#if os(iOS) || os(macOS) || os(visionOS)
                EditorToolBarView(state: state)
#endif

                RichTextEditor(
                    context: _state,
                    viewConfiguration: { _ in

                    }
                )
                .cornerRadius(10)
            }
            .padding(10)
            .toolbar {
                ToolbarItem() {
                    Button(action: {
                        print("Exported JSON == \(state.output())")
                    }, label: {
                        Image(systemName: "checkmark")
                            .padding()
                    })
                }
            }
            .background(colorScheme == .dark ? .black : .gray.opacity(0.07))
            .navigationTitle("Rich Editor")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}
