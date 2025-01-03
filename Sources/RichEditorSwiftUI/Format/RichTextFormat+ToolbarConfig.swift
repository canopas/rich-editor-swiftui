//
//  RichTextFormat+ToolbarConfig.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/11/24.
//

#if os(iOS) || os(macOS) || os(visionOS)
  import SwiftUI

  extension RichTextFormat {

    /// This type can be used to configure a format toolbar.
    public struct ToolbarConfig {

      public init(
        headers: [HeaderType] = .all,
        alignments: [RichTextAlignment] = .all,
        colorPickers: [RichTextColor] = [.foreground],
        colorPickersDisclosed: [RichTextColor] = [],
        fontPicker: Bool = true,
        fontSizePicker: Bool = true,
        indentButtons: Bool = true,
        lineSpacingPicker: Bool = false,
        styles: [RichTextStyle] = .all,
        otherMenu: [RichTextOtherMenu] = .all,
        superscriptButtons: Bool = true
      ) {
        self.headers = headers
        self.alignments = alignments
        self.colorPickers = colorPickers
        self.colorPickersDisclosed = colorPickersDisclosed
        self.fontPicker = fontPicker
        self.fontSizePicker = fontSizePicker
        self.indentButtons = indentButtons
        self.lineSpacingPicker = lineSpacingPicker
        self.styles = styles
        self.otherMenu = otherMenu
        #if os(macOS)
          self.superscriptButtons = superscriptButtons
        #else
          self.superscriptButtons = false
        #endif
      }

      public var headers: [HeaderType]
      public var alignments: [RichTextAlignment]
      public var colorPickers: [RichTextColor]
      public var colorPickersDisclosed: [RichTextColor]
      public var fontPicker: Bool
      public var fontSizePicker: Bool
      public var indentButtons: Bool
      public var lineSpacingPicker: Bool
      public var styles: [RichTextStyle]
      public var otherMenu: [RichTextOtherMenu]
      public var superscriptButtons: Bool
    }
  }

  extension RichTextFormat.ToolbarConfig {

    /// The standard rich text format toolbar configuration.
    public static var standard: Self { .init() }
  }

  extension View {

    /// Apply a rich text format toolbar style.
    public func richTextFormatToolbarConfig(
      _ value: RichTextFormat.ToolbarConfig
    ) -> some View {
      self.environment(\.richTextFormatToolbarConfig, value)
    }
  }

  extension RichTextFormat.ToolbarConfig {

    fileprivate struct Key: EnvironmentKey {

      public static var defaultValue: RichTextFormat.ToolbarConfig {
        .init()
      }
    }
  }

  extension EnvironmentValues {

    /// This value can bind to a format toolbar config.
    public var richTextFormatToolbarConfig: RichTextFormat.ToolbarConfig {
      get { self[RichTextFormat.ToolbarConfig.Key.self] }
      set { self[RichTextFormat.ToolbarConfig.Key.self] = newValue }
    }
  }
#endif
