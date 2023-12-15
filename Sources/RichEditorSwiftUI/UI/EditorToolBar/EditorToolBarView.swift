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
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 5, content: {
                ForEach(EditorTool.allCases, id: \.self) { tool in
                    EditorToolBarCell(tool: tool, isSelected: appliedTools.contains(where: { $0.key == tool.getTextSpanStyle().key }), onToolSelect: onToolSelect)
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
    let onToolSelect: (TextSpanStyle) -> Void
    
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
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
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
                            onToolSelect(EditorTool.header(header).getTextSpanStyle())
                        }, label: {
                            Text(header.title)
                                .font(header.fontStyle)
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
        }
    }
}
