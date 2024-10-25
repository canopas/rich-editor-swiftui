//
//  EditorToolBarView.swift
//
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI

public struct EditorToolBarView: View {
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var state: RichEditorState

    var selectedColor: Color {
        colorScheme == .dark ? .white.opacity(0.3) : .gray.opacity(0.1)
    }

    public init(state: RichEditorState) {
        self.state = state
    }

    public var body: some View {
        LazyHStack(spacing: 5, content: {
            ForEach(EditorTool.allCases, id: \.self) { tool in
                if tool.isContainManu {
                    TitleStyleButton(tool: tool, appliedTools: state.activeStyles, setStyle: state.updateStyle(style:))
                } else {
//                    if tool != .list() {
                        ToggleStyleButton(tool: tool, appliedTools: state.activeStyles, onToolSelect: state.toggleStyle(style:))
//                    }
                }
            }
        })
        .frame(height: 50)
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(selectedColor)
        .clipShape(.capsule)
    }
}

private struct ToggleStyleButton: View {
    @Environment(\.colorScheme) var colorScheme

    let tool: EditorTool
    let appliedTools: Set<TextSpanStyle>
    let onToolSelect: (TextSpanStyle) -> Void

    private var isSelected: Bool {
        tool.isSelected(appliedTools)
    }

    var normalDarkColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var selectedColor: Color {
        colorScheme == .dark ? .gray.opacity(0.4) : .gray.opacity(0.1)
    }

    var body: some View {
        Button(action: {
            onToolSelect(tool.getTextSpanStyle())
        }, label: {
            HStack(alignment: .center, spacing: 4, content: {
                Image(systemName: tool.systemImageName)
                    .font(.title)
            })
            .foregroundColor(isSelected ? .blue : normalDarkColor)
            .frame(width: 40, height: 40, alignment: .center)
            .background(isSelected ? selectedColor : Color.clear)
            .cornerRadius(5)
            .padding(.vertical, 5)
        })
    }
}

struct TitleStyleButton: View {
    @Environment(\.colorScheme) var colorScheme

    let tool: EditorTool
    let appliedTools: Set<TextSpanStyle>
    let setStyle: (TextSpanStyle) -> Void

    private var isSelected: Bool {
        tool.isSelected(appliedTools)
    }

    @State var isExpanded: Bool = false

    var normalDarkColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var body: some View {

        Menu(content: {
            ForEach(HeaderType.allCases, id: \.self) { header in
                Button(action: {
                    isExpanded = false
                    setStyle(EditorTool.header(header).getTextSpanStyle())
                }, label: {
                    if hasStyle(header.getTextSpanStyle()) {
                        Label(header.title, systemImage:"checkmark")
                            .foregroundColor(normalDarkColor)
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
            .foregroundColor(isSelected ? .blue : normalDarkColor)
            .frame(width: 50, height: 40, alignment: .center)
            .padding(.horizontal, 3)
            .background(isSelected ? Color.gray.opacity(0.1) : Color.clear)
            .cornerRadius(5)
            .padding(.vertical, 5)
        })
#if !os(tvOS)
        .onTapGesture {
            isExpanded.toggle()
        }
#endif
    }
    

    func hasStyle(_ style: TextSpanStyle) -> Bool {
        return appliedTools.contains(where: { $0.key == style.key })
    }
}
