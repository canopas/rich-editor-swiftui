//
//  RichTextFormat+Toolbar.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/11/24.
//

#if os(iOS) || os(macOS) || os(visionOS)
  import SwiftUI

  extension RichTextFormat {

    /**
     This horizontal toolbar provides text format controls.

     This toolbar adapts the layout based on horizontal size
     class. The control row is split in two for compact size,
     while os(macOS) and regular sizes get a single row.

     You can configure and style the view by applying config
     and style view modifiers to your view hierarchy:

     ```swift
     VStack {
     ...
     }
     .richTextFormatToolbarStyle(...)
     .richTextFormatToolbarConfig(...)
     ```
     */
    public struct Toolbar: RichTextFormatToolbarBase {

      /**
         Create a rich text format sheet.

         - Parameters:
         - context: The context to apply changes to.
         */
      public init(
        context: RichEditorState
      ) {
        self._context = ObservedObject(wrappedValue: context)
      }

      @ObservedObject
      private var context: RichEditorState

      @Environment(\.richTextFormatToolbarConfig)
      var config

      @Environment(\.richTextFormatToolbarStyle)
      var style

      @Environment(\.horizontalSizeClass)
      private var horizontalSizeClass

      public var body: some View {
        VStack(spacing: style.spacing) {
          controls
          if hasColorPickers {
            Divider()
            colorPickers(for: context)
          }
        }
        .labelsHidden()
        .padding(.vertical, style.padding)
        .environment(\.sizeCategory, .medium)
        //            .background(background)
        #if os(macOS)
          .frame(minWidth: 650)
        #endif
      }
    }
  }

  // MARK: - Views

  extension RichTextFormat.Toolbar {

    fileprivate var useSingleLine: Bool {
      #if os(macOS)
        true
      #else
        horizontalSizeClass == .regular
      #endif
    }
  }

  extension RichTextFormat.Toolbar {

    fileprivate var background: some View {
      Color.clear
        .overlay(Color.primary.opacity(0.1))
        .shadow(color: .black.opacity(0.1), radius: 5)
        .edgesIgnoringSafeArea(.all)
    }

    @ViewBuilder
    fileprivate var controls: some View {
      if useSingleLine {
        HStack {
          controlsContent
        }
        .padding(.horizontal, style.padding)
      } else {
        VStack(spacing: style.spacing) {
          controlsContent
        }
        .padding(.horizontal, style.padding)
      }
    }

    @ViewBuilder
    fileprivate var controlsContent: some View {
      HStack {
        #if os(macOS)
          headerPicker(context: context)
          fontPicker(value: $context.fontName)
            .onChangeBackPort(of: context.fontName) { newValue in
              context.updateStyle(style: .font(newValue))
            }
        #endif
        styleToggleGroup(for: context)
        otherMenuToggleGroup(for: context)
        if !useSingleLine {
          Spacer()
        }
        fontSizePicker(for: context)
        if horizontalSizeClass == .regular {
          Spacer()
        }
      }
      HStack {
        #if !macOS
          headerPicker(context: context)
        #endif
        alignmentPicker(context: context)
        //            superscriptButtons(for: context, greedy: false)
        //            indentButtons(for: context, greedy: false)
      }
    }
  }
#endif
