# RichEditorSwiftUI

iOS WYSIWYG Rich editor for SwiftUI.

<p align="center">
    <img src="./docs/sample.gif" height="640" />
</p>


## Features

The editor offers the following <b>options</b>:

- [x] **Bold**
- [x] *Italic*
- [x] <u>Underline</u>
- [x] Different Heading

## How to add in your project

Add the dependency

```
 import XYZRichEditor
```

## How to use ?

```
struct EditorView: View {
    @ObservedObject var state: RichEditorState = .ini(input: "Hello World")
    
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