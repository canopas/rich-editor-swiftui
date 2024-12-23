//
//  RichTextFont+Picker.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/11/24.
//

import SwiftUI

extension RichTextFont {

    /**
     This font picker can be used to pick a font from a list,
     using ``RichTextFont/PickerFont/all`` as default fonts.

     This view uses a plain `Picker`, which renders fonts on
     macOS, but not on iOS. To render fonts correctly on all
     platforms, you can use a ``RichTextFont/ListPicker`` or
     a ``RichTextFont/ForEachPicker``.

     You can configure this picker by applying a config view
     modifier to your view hierarchy:

     ```swift
     VStack {
        RichTextFont.Picker(...)
        ...
     }
     .richTextFontPickerConfig(...)
     ```

     Note that this picker will not apply all configurations.
     */
    public struct Picker: View {

        /**
         Create a font picker.

         - Parameters:
           - selection: The selected font name.
         */
        public init(
            selection: Binding<FontName>
        ) {
            self._selection = selection
            self.selectedFont = Config.Font.all.first
        }

        public typealias Config = RichTextFont.PickerConfig
        public typealias Font = Config.Font
        public typealias FontName = Config.FontName

        @State
        private var selectedFont: Font?

        @Binding
        private var selection: FontName

        @Environment(\.richTextFontPickerConfig)
        private var config

        public var body: some View {
            SwiftUI.Picker(selection: $selection) {
                ForEach(config.fonts) { font in
                    RichTextFont.PickerItem(
                        font: font,
                        fontSize: config.fontSize,
                        isSelected: false
                    )
                    .tag(font.fontName)
                }
            } label: {
                EmptyView()
            }
        }
    }
}

extension RichTextFont.PickerFont {

    /**
     A system font has a font name that may be resolved to a
     different name when picked. We must thus try to pattern
     match, using the currently selected font name.
     */
    fileprivate func matches(_ fontName: String) -> Bool {
        let compare = fontName.lowercased()
        let fontName = self.fontName.lowercased()
        if fontName == compare { return true }
        if compare.hasPrefix(fontName.replacingOccurrences(of: " ", with: "")) {
            return true
        }
        if compare.hasPrefix(fontName.replacingOccurrences(of: " ", with: "-"))
        {
            return true
        }
        return false
    }

    /**
     Use the selected font name as tag for the selected font.
     */
    fileprivate func tag(for selectedFont: Self?, selectedName: String)
        -> String
    {
        let isSelected = fontName == selectedFont?.fontName
        return isSelected ? selectedName : fontName
    }
}

//extension View {
//
//    func withPreviewPickerStyles() -> some View {
//        NavigationView {
//            #if macOS
//            Color.clear
//            #endif
//            ScrollView {
//                VStack(spacing: 10) {
//                    self.label("Default")
//                    self.pickerStyle(.automatic).label(".automatic")
//                    self.pickerStyle(.inline).label(".inline")
//                    #if os(iOS) || macOS
//                    self.pickerStyle(.menu).label(".menu")
//                    #endif
//                    #if iOS
//                    if #available(iOS 16.0, *) {
//                        pickerStyle(.navigationLink).label(".navigationLink")
//                    }
//                    #endif
//                    #if os(iOS) || macOS
//                    if #available(iOS 17.0, os(macOS) 14.0, watchOS 10.0, *) {
//                        pickerStyle(.palette).label(".palette")
//                    }
//                    #endif
//                    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
//                    self.pickerStyle(.segmented).label(".segmented")
//                    #endif
//                    #if iOS
//                    pickerStyle(.wheel).label(".wheel")
//                    #endif
//                }
//            }
//        }
//    }
//}
//
//private extension View {
//
//    func label(_ title: String) -> some View {
//        VStack {
//            Text(title)
//                .font(.footnote)
//                .foregroundStyle(.secondary)
//            self
//            Divider()
//        }
//    }
//}
