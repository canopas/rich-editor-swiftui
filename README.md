
<img width="930" alt="mobile apps banner" src="https://github.com/canopas/rich-editor-swiftui/assets/73588408/84c94bbd-7952-45cb-9bfb-95e0687b37b0">

# RichEditorSwiftUI

![RichEditorSwiftUI (1)](https://github.com/canopas/rich-editor-swiftui/assets/73588408/8c3013ae-8a27-4ebc-a511-51e726825c4b)

## A swift-based  library to make rich text editing very easy with SwiftUI.

<img src="./docs/sample.gif" height="640" />    <img src="./docs/dark_mode_sample.gif" height="640" />

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
 import RichEditorSwiftUI
```

## How to use?

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
For bugs, questions, and discussions please use the [Github Issues](https://github.com/canopas/rich-editor-swiftui/issues).


## Credits
RichEditor for SwiftUI is owned and maintained by the [Canopas team](https://canopas.com/). For project updates and releases, you can follow them on X at [@canopas_eng](https://x.com/canopas_eng).

A similar library is also available for Android in Jetpack Compose [here](https://github.com/canopas/rich-editor-compose).

RichTextKit: https://github.com/danielsaidi/RichTextKit

<a href="https://canopas.com/contact"><img src="https://github.com/canopas/rich-editor-swiftui/assets/73588408/e03fe013-03e8-429d-828f-5066d3775258" width=250></a>

# Licence

```
Copyright 2023 Canopas Software LLP

Licensed under the Apache License, Version 2.0 (the "License");
You won't be using this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
