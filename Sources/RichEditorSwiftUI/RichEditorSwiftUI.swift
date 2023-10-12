// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct RichEditorView: View {
    
    @State var selectedTools: [EditorTool] = []

    public init(selectedTools: [EditorTool] = []) {
        self.selectedTools = selectedTools
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false, content: {
            VStack(spacing: 0, content: {
                EditorToolBarView(appliedTools: selectedTools, onToolSelect: { tool in
                    if selectedTools.contains(where: { $0 == tool }) {
                        selectedTools.removeAll(where: { $0 == tool })
                    } else {
                        selectedTools.append(tool)
                    }
                })
                
                // Editor comes here
            })
        })
    }
}
