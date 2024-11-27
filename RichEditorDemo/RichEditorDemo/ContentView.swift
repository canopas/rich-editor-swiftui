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
    @State private var fileName: String = ""
    @State private var exportFormat: RichTextDataFormat? = nil
    @State private var otherExportFormat: RichTextExportOption? = nil
    @State private var exportService: StandardRichTextExportService = .init()

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
                ToolbarItemGroup(placement: .automatic) {
                    toolBarGroup
                }
            }
            .background(colorScheme == .dark ? .black : .gray.opacity(0.07))
            .navigationTitle("Rich Editor")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
            .alert("Enter file name", isPresented: getBindingAlert()) {
                TextField("Enter file name", text: $fileName)
                Button("OK", action: submit)
            } message: {
                Text("Please enter file name")
            }
        }
    }

    var toolBarGroup: some View {
        return Group {
                RichTextExportMenu.init(
                    formatAction: { format in
                        exportFormat = format
                    },
                    otherOptionAction: { format in
                        otherExportFormat = format
                    }
                )
                .frame(width: 25, alignment: .center)
                Button(
                    action: {
                        print("Exported JSON == \(state.outputAsString())")
                    },
                    label: {
                        Image(systemName: "printer.inverse")
                            .padding()
                    }
                )
                .frame(width: 25, alignment: .center)
                Toggle(isOn: $isInspectorPresented) {
                    Image.richTextFormatBrush
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                }
                .frame(width: 25, alignment: .center)
            }
    }

    func getBindingAlert() -> Binding<Bool> {
        .init(get: { exportFormat != nil || otherExportFormat != nil }, set: { newValue in
            exportFormat = nil
            otherExportFormat = nil
        })
    }

    func submit() {
        guard !fileName.isEmpty else { return }
        var path: URL?

        if let exportFormat {
            path = try? exportService.generateExportFile(withName: fileName, content: state.attributedString, format: exportFormat)
        }
        if let otherExportFormat {
            switch otherExportFormat {
            case .pdf:
                path = try? exportService.generatePdfExportFile(withName: fileName, content: state.attributedString)
            case .json:
                path = try? exportService.generateJsonExportFile(withName: fileName, content: state.richText)
            }
        }
        if let path {
            print("Exported at path == \(path)")
        }
    }
}
