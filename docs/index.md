# RichEditorSwiftUI

iOS WYSIWYG Rich editor for SwiftUI.

<img src="./docs/sample.gif" height="640" />

## Features

The editor offers the following <b>options</b>:

- [x] **Bold**
- [x] *Italic*
- [x] <u>Underline</u>
- [x] Different Heading

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding RichEditorSwiftUI as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/canopas/rich-editor-swiftui.git", .upToNextMajor(from: "1.0.0"))
]
```

### CocoaPods

[CocoaPods][] is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate RichEditorSwiftUI into your Xcode project using CocoaPods, specify it in your Podfile:

    target 'YourAppName' do
        pod 'RichEditorSwiftUI', '~> 1.0.0'
    end

[CocoaPods]: https://cocoapods.org

## How to add in your project

Add the dependency

```
 import XYZRichEditor
```

## How to use ?

```
struct EditorView: View {
    @ObservedObject var state: RichEditorState = .init(input: "Hello World")
    
    var body: some View {
        RichEditor(state: _state)
            .padding(10)
    }
}
```
# Demo
[Sample](https://github.com/canopas/rich-editor-swiftui/tree/main/RichEditorDemo) app demonstrates how simple the usage of the library actually is.

# Bugs and Feedback
For bugs, questions and discussions please use the [Github Issues](https://github.com/canopas/rich-editor-swiftui/issues).


## Credits
RichEditor for SwiftUI is owned and maintained by the [Canopas team](https://canopas.com/). For project updates and releases, you can follow them on Twitter at [@canopassoftware](https://twitter.com/canopassoftware).

RichTextKit: https://github.com/danielsaidi/RichTextKit

