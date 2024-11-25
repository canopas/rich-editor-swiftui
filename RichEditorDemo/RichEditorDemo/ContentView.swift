//
//  ContentView.swift
//  RichEditorDemo
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import RichEditorSwiftUI
import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var state: RichEditorState
    @State private var isInspectorPresented = false

    init(state: RichEditorState? = nil) {
        if let state {
            self.state = state
        } else {
            if let richText = readJSONFromFile(
                fileName: "Sample_json",
                type: RichText.self)
            {
                self.state = .init(richText: richText)
            } else {
                self.state = .init(input: "Hello World!")
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                #if os(macOS)
                    RichTextFormat.Toolbar(context: state)
                #endif

                RichTextEditor(
                    context: _state,
                    viewConfiguration: { _ in

                    }
                )
                .cornerRadius(10)

                #if os(iOS)
                    RichTextKeyboardToolbar(
                        context: state,
                        leadingButtons: { $0 },
                        trailingButtons: { $0 },
                        formatSheet: { $0 }
                    )
                #endif
            }
            .inspector(isPresented: $isInspectorPresented) {
                RichTextFormat.Sidebar(context: state)
                    #if os(macOS)
                        .inspectorColumnWidth(min: 200, ideal: 200, max: 315)
                    #endif
            }
            .padding(10)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(
                        action: {
                            print("Exported JSON == \(state.output())")
                        },
                        label: {
                            Image(systemName: "printer.inverse")
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
