//
//  EditorToolBarView.swift
//
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI

struct EditorToolBarView: View {
    
    let appliedTools: Set<TextSpanStyle>
    let onToolSelect: (TextSpanStyle) -> Void
    
    var body: some View {
        LazyHStack(spacing: 5, content: {
            ForEach(EditorTool.allCases, id: \.self) { tool in
                EditorToolBarCell(tool: tool, appliedTools: appliedTools, onToolSelect: onToolSelect)
            }
        })
        .frame(height: 50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.1))
    }
}

private struct EditorToolBarCell: View {
    
    let tool: EditorTool
    let appliedTools: Set<TextSpanStyle>
    let onToolSelect: (TextSpanStyle) -> Void
    
    private var isSelected: Bool {
        tool.isSelected(appliedTools)
    }
    
    @State var isExpanded: Bool = false
    
    var body: some View {
        if !tool.isContainManu {
        Button(action: {
            isExpanded.toggle()
            if !tool.isContainManu {
                onToolSelect(tool.getTextSpanStyle())
            }
        }, label: {
                HStack(alignment: .center, spacing: 4, content: {
                    Image(systemName: tool.systemImageName)
                        .font(.title)
                    if tool.isContainManu {
                        Image(systemName: "chevron.down")
                            .font(.subheadline)
                            .rotationEffect(.degrees(isExpanded ? 0 : 180))
                            .animation(.spring(), value: isExpanded)
                    }
                })
                .foregroundColor(isSelected ? .blue : .black)
                .frame(width: tool.isContainManu ? 60 : 45, height: 50, alignment: .center)
                .padding(.horizontal, 3)
                .background(isSelected ? .gray.opacity(0.1) : .clear)
        })
        } else {
            Menu(content: {
                ForEach(HeaderOptions.allCases, id: \.self) { header in
                    Button(action: {
                        isExpanded = false
                        onToolSelect(EditorTool.header(header).getTextSpanStyle())
                    }, label: {
                        Text(header.title)
                            .font(header.fontStyle)
                            .foregroundColor(appliedTools.contains(where: { $0.key == header.getTextSpanStyle().key }) ? .blue : .black)
                    })
                }
            }, label: {
                HStack(alignment: .center, spacing: 4, content: {
                    Image(systemName: tool.systemImageName)
                        .font(.title)
                    if tool.isContainManu {
                        Image(systemName: "chevron.down")
                            .font(.subheadline)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .animation(.spring(), value: isExpanded)
                    }
                })
                .foregroundColor(isSelected ? .blue : .black)
                .frame(width: tool.isContainManu ? 60 : 45, height: 50, alignment: .center)
                .padding(.horizontal, 3)
                .background(isSelected ? .gray.opacity(0.1) : .clear)
            })
            .onTapGesture {
                isExpanded.toggle()
            }
        }
    }
}
