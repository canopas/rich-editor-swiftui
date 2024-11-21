//
//  EditorToolBarView.swift
//
//
//  Created by Divyesh Vekariya on 11/10/23.
//

import SwiftUI

#if iOS || macOS || os(visionOS)
public struct EditorToolBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.richTextKeyboardToolbarStyle) private var style

    @ObservedObject var state: RichEditorState

    var selectedColor: Color {
        colorScheme == .dark ? .white.opacity(0.3) : .gray.opacity(0.1)
    }

    var background: some View {
        Color.clear
            .overlay(Color.primary.opacity(0.1))
            .shadow(color: .black.opacity(0.1), radius: 5)
            .edgesIgnoringSafeArea(.all)
    }

    public init(state: RichEditorState) {
        self.state = state
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
        HStack(spacing: 5, content: {
            Section {
                ForEach(EditorTextStyleTool.allCases, id: \.self) { tool in
                    if tool.isContainManu {
                        TitleStyleButton(tool: tool, appliedTools: state.activeStyles, setStyle: state.updateStyle(style:))
                        RTEVDivider()
                    } else {
                        //                    if tool != .list() {
                        ToggleStyleButton(tool: tool, appliedTools: state.activeStyles, onToolSelect: state.toggleStyle(style:))
                        //                    }
                    }
                }
            }

            RTEVDivider()

            Section {
                RichTextFont.SizePickerStack(context: state)
                
            }
        })
        #if os(iOS)
        .frame(height: 40)
        #else
        .frame(height: 40)
        #endif

            RichTextFormat.Toolbar(context: state)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background)
        .cornerRadius(8)

    }
}

private struct ToggleStyleButton: View {
    @Environment(\.colorScheme) var colorScheme

    let tool: EditorTextStyleTool
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
            HStack(alignment: .center, spacing: 0, content: {
                Image(systemName: tool.systemImageName)
                #if os(iOS)
                    .frame(width: 25, height: 25)
                #else
                    .frame(width: 20, height: 20)
                #endif
            })
            .foregroundColor(isSelected ? .blue : normalDarkColor)
            #if os(iOS)
            .frame(width: 30, height: 30, alignment: .center)
            #endif
            .background(isSelected ? selectedColor : Color.clear)
            .cornerRadius(5)
        })
    }
}

struct TitleStyleButton: View {
    @Environment(\.colorScheme) var colorScheme

    let tool: EditorTextStyleTool
    let appliedTools: Set<TextSpanStyle>
    let setStyle: (TextSpanStyle) -> Void

    private var isSelected: Bool {
        tool.isSelected(appliedTools)
    }

    var normalDarkColor: Color {
        colorScheme == .dark ? .white : .black
    }

    @State var selection: HeaderType = .default

    var body: some View {
        Picker("", selection: $selection) {
            ForEach(HeaderType.allCases, id: \.self) { header in
                Text(header.title)
            }
        }
        .onChangeBackPort(of: selection) { newValue in
            setStyle(EditorTextStyleTool.header(selection).getTextSpanStyle())
        }
    }
    

    func hasStyle(_ style: TextSpanStyle) -> Bool {
        return appliedTools.contains(where: { $0.key == style.key })
    }
}

struct RTEVDivider: View {
    var body: some View {
        Rectangle()
            .frame(width: 1, height: 20)
            .foregroundColor(.secondary)
    }
}
#endif
