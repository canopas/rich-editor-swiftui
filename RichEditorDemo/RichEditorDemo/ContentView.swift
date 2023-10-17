//
//  ContentView.swift
//  RichEditorDemo
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI
import RichEditorSwiftUI

struct ContentView: View {
    
    @State var text: NSMutableAttributedString = .init(string: "This is test text and it is too sort to see in the screen but it is fine to show smale string as it is easy to find bugs from small amout of code.")
//    @State var appliedTools: [EditorTool] = []
 
    var body: some View {
        VStack {
            RichEditorView(text: $text)
        }
        .padding()
    }
}
