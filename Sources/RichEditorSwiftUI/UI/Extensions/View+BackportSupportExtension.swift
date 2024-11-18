//
//  View+BackportSupportExtension.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 30/10/24.
//

import SwiftUI

extension View {
    nonisolated public func onChangeBackPort<V>(of value: V, _ action: @escaping (_ newValue: V) -> Void) -> some View where V : Equatable {
        Group {
            if #available(iOS 17.0, macOS 14.0, *) {
                self
                //iOS17~
                    .onChange(of: value) { oldValue, newValue in
                        action(newValue)
                    }
            } else {
                //up to iOS16
                self
                    .onChange(of: value) { newValue in
                        action(newValue)
                    }
            }
        }
    }
}
