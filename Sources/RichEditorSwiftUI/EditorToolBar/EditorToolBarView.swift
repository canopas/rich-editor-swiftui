//
//  EditorToolBarView.swift
//
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI

struct EditorToolBarView: View {
    
    let appliedTools: [EditorTool]
    let onToolSelect: (EditorTool) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 5, content: {
                ForEach(EditorTool.allCases, id: \.self) { tool in
                    EditorToolBarCell(tool: tool, isSelected: appliedTools.contains(where: { $0 == tool }), onToolSelect: onToolSelect)
                }
            })
            .padding(.horizontal, 3)
            .padding(.horizontal)
        }
        .background(.gray.opacity(0.1))
        .frame(height: 50)
    }
}

private struct EditorToolBarCell: View {
    
    let tool: EditorTool
    let isSelected: Bool
    let onToolSelect: (EditorTool) -> Void
    
    @State var isExpanded: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 4, content: {
            Image(systemName: tool.systemName)
                .font(.title)
            if tool.isContainManu {
                Image(systemName: "chevron.down")
                    .font(.subheadline)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.spring(), value: isExpanded)
            }
        })
        .foregroundColor(isSelected ? .blue : nil)
        .frame(width: tool.isContainManu ? 60 : 45, height: 50, alignment: .center)
        .padding(.horizontal, 3)
        .background(isSelected ? .gray.opacity(0.1) : .clear)
        .onTapGesture {
            isExpanded.toggle()
            onToolSelect(tool)
        }
    }
}


#Preview {
    @State var selectedTools: [EditorTool] = []
    return EditorToolBarView(appliedTools: selectedTools, onToolSelect: { tool in
        if selectedTools.contains(where: { $0 == tool }) {
            selectedTools.removeAll(where: { $0 == tool })
        } else {
            selectedTools.append(tool)
        }
    })
}
