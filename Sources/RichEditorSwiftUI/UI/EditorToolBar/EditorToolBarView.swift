//
//  EditorToolBarView.swift
//
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI

struct EditorToolBarView: View {
    @ObservedObject var state: RichEditorState
    
    var body: some View {
        LazyHStack(spacing: 5, content: {
            ForEach(EditorTool.allCases, id: \.self) { tool in
                if tool.isContainManu {
                    TitleStyleButton(tool: tool, appliedTools: state.activeStyles, setStyle: state.updateStyle(style:))
                } else {
                    ToggleStyleButton(tool: tool, appliedTools: state.activeStyles, onToolSelect: state.toggleStyle(style:))
                }
            }
        })
        .frame(height: 50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
    }
}

private struct ToggleStyleButton: View {
    
    let tool: EditorTool
    let appliedTools: Set<TextSpanStyle>
    let onToolSelect: (TextSpanStyle) -> Void
    
    private var isSelected: Bool {
        tool.isSelected(appliedTools)
    }
    
    
    var body: some View {
        Button(action: {
            onToolSelect(tool.getTextSpanStyle())
        }, label: {
                HStack(alignment: .center, spacing: 4, content: {
                    Image(systemName: tool.systemImageName)
                        .font(.title)
                })
                .foregroundColor(isSelected ? .blue : .black)
                .frame(width: 45, height: 50, alignment: .center)
                .padding(.horizontal, 3)
                .background(isSelected ? Color.gray.opacity(0.1) : Color.clear)
        })
    }
}

struct TitleStyleButton: View {
    let tool: EditorTool
    let appliedTools: Set<TextSpanStyle>
    let setStyle: (TextSpanStyle) -> Void
    
    private var isSelected: Bool {
        tool.isSelected(appliedTools)
    }
    
    @State var isExpanded: Bool = false
    
    var body: some View {
        
        Menu(content: {
            ForEach(HeaderOptions.allCases, id: \.self) { header in
                Button(action: {
                    isExpanded = false
                    setStyle(EditorTool.header(header).getTextSpanStyle())
                }, label: {
                    if hasStayle(header.getTextSpanStyle()) {
                        Label(header.title, systemImage:"checkmark")
                            .foregroundColor(.blue)
                    } else {
                        Text(header.title)
                    }
                })
            }
        }, label: {
            HStack(alignment: .center, spacing: 4, content: {
                Image(systemName: tool.systemImageName)
                    .font(.title)
                
                Image(systemName: "chevron.down")
                    .font(.subheadline)
            })
            .foregroundColor(isSelected ? .blue : .black)
            .frame(width: 60, height: 50, alignment: .center)
            .padding(.horizontal, 3)
            .background(isSelected ? Color.gray.opacity(0.1) : Color.clear)
        })
        .onTapGesture {
            isExpanded.toggle()
        }
        
    }
    
    func hasStayle(_ style: TextSpanStyle) -> Bool {
        return appliedTools.contains(where: { $0.key == style.key })
    }
}
