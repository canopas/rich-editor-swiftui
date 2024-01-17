//
//  ContentView.swift
//  RichEditorDemo
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI
import RichEditorSwiftUI

struct ContentView: View {
    @ObservedObject var state: RichEditorState
    
    init(state: RichEditorState? = nil) {
        if let state {
            self.state = state
        } else {
            if let richText = readJSONFromFile(fileName: "Sample_json", type: RichText.self) {
                self.state = .init(input: richText.text, spans: richText.spans)
            } else {
                self.state = .init(input: "Hello World!")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                RichEditor(state: _state)
            }
            .padding(10)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("Export JSON")
                    }, label: {
                        Image(systemName: "checkmark")
                            .padding()
                    })
                }
            }
            .navigationTitle("Rich Editor")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
