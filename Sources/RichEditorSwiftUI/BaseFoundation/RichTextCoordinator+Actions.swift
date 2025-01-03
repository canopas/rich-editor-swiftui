//
//  RichTextCoordinator+Actions.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import Foundation

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    import SwiftUI

    extension RichTextCoordinator {

        func handle(_ action: RichTextAction?) {
            guard let action else { return }
            switch action {
            case .copy: textView.copySelection()
            case .dismissKeyboard:
                textView.resignFirstResponder()
            //            case .pasteImage(let image):
            //                pasteImage(image)
            //            case .pasteImages(let images):
            //                pasteImages(images)
            //            case .pasteText(let text):
            //                pasteText(text)
            case .print:
                break
            case .redoLatestChange:
                textView.redoLatestChange()
                syncContextWithTextView()
            case .selectRange(let range):
                setSelectedRange(to: range)
            case .setAlignment(let alignment):
                textView.setRichTextAlignment(alignment)
            case .setAttributedString(let string):
                setAttributedString(to: string)
            case .setColor(let color, let newValue):
                setColor(color, to: newValue)
            case .setHighlightedRange(let range):
                setHighlightedRange(to: range)
            case .setHighlightingStyle(let style):
                textView.highlightingStyle = style
            case .setStyle(let style, let newValue):
                setStyle(style, to: newValue)
            case .stepFontSize(let points):
                textView.stepRichTextFontSize(points: points)
                syncContextWithTextView()
            case .stepIndent(_):
                //                textView.stepRichTextIndent(points: points)
                return
            case .stepLineSpacing(_):
                //                textView.stepRichTextLineSpacing(points: points)
                return
            case .stepSuperscript(_):
                //                textView.stepRichTextSuperscriptLevel(points: points)
                return
            case .toggleStyle(_):
                //                textView.toggleRichTextStyle(style)
                return
            case .undoLatestChange:
                textView.undoLatestChange()
                syncContextWithTextView()
            case .setHeaderStyle(let style):
                let size = style.fontSizeMultiplier * .standardRichTextFontSize
                let range = textView.textString.getHeaderRangeFor(
                    textView.selectedRange
                )
                var font = textView.richTextFont(at: range)
                font = font?.withSize(size)
                textView
                    .setRichTextFont(font ?? .standardRichTextFont, at: range)
            case .setLink(let link):
                if let link, link != self.context.link {
                    setLink(link)
                } else {
                    removeLink()
                }
            }
        }
    }

    extension RichTextCoordinator {

        //    func paste<T: RichTextInsertable>(_ data: RichTextInsertion<T>) {
        //        if let data = data as? RichTextInsertion<ImageRepresentable> {
        //            pasteImage(data)
        //        } else if let data = data as? RichTextInsertion<[ImageRepresentable]> {
        //            pasteImages(data)
        //        } else if let data = data as? RichTextInsertion<String> {
        //            pasteText(data)
        //        } else {
        //            print("Unsupported media type")
        //        }
        //    }
        //
        //    func pasteImage(_ data: RichTextInsertion<ImageRepresentable>) {
        //        textView.pasteImage(
        //            data.content,
        //            at: data.index,
        //            moveCursorToPastedContent: data.moveCursor
        //        )
        //    }
        //
        //    func pasteImages(_ data: RichTextInsertion<[ImageRepresentable]>) {
        //        textView.pasteImages(
        //            data.content,
        //            at: data.index,
        //            moveCursorToPastedContent: data.moveCursor
        //        )
        //    }

        //    func pasteText(_ data: RichTextInsertion<String>) {
        //        textView.pasteText(
        //            data.content,
        //            at: data.index,
        //            moveCursorToPastedContent: data.moveCursor
        //        )
        //    }

        func setAttributedString(to newValue: NSAttributedString?) {
            guard let newValue else { return }
            textView.setRichText(newValue)
        }

        // TODO: This code should be handled by the component
        func setColor(_ color: RichTextColor, to val: ColorRepresentable) {
            var applyRange: NSRange?
            if textView.hasSelectedRange {
                applyRange = textView.selectedRange
            }
            guard let attribute = color.attribute else { return }
            if let applyRange {
                textView.setRichTextColor(color, to: val, at: applyRange)
            } else {
                textView.setRichTextAttribute(attribute, to: val)
            }
        }

        func setHighlightedRange(to range: NSRange?) {
            resetHighlightedRangeAppearance()
            guard let range = range else { return }
            setHighlightedRangeAppearance(for: range)
        }

        func setHighlightedRangeAppearance(for range: NSRange) {
            let back = textView.richTextColor(.background, at: range) ?? .clear
            let fore =
                textView.richTextColor(.foreground, at: range) ?? .textColor
            highlightedRangeOriginalBackgroundColor = back
            highlightedRangeOriginalForegroundColor = fore
            let style = textView.highlightingStyle
            let background = ColorRepresentable(style.backgroundColor)
            let foreground = ColorRepresentable(style.foregroundColor)
            textView.setRichTextColor(.background, to: background, at: range)
            textView.setRichTextColor(.foreground, to: foreground, at: range)
        }

        func setIsEditable(to newValue: Bool) {
            #if os(iOS) || os(macOS) || os(visionOS)
                if newValue == textView.isEditable { return }
                textView.isEditable = newValue
            #endif
        }

        func setIsEditing(to newValue: Bool) {
            if newValue == textView.isFirstResponder { return }
            if newValue {
                #if os(iOS) || os(visionOS)
                    textView.becomeFirstResponder()
                #else
                    print("macOS currently doesn't resign first responder.")
                #endif
            } else {
                #if os(iOS) || os(visionOS)
                    textView.resignFirstResponder()
                #else
                    print("macOS currently doesn't resign first responder.")
                #endif
            }
        }

        func setSelectedRange(to range: NSRange) {
            if range == textView.selectedRange { return }
            textView.selectedRange = range
        }

        func setStyle(_ style: RichTextStyle, to newValue: Bool) {
            let hasStyle = textView.richTextStyles.hasStyle(style)
            guard newValue != hasStyle else { return }
            textView.setRichTextStyle(style, to: newValue)
        }

        func setLink(_ link: String) {
            let style: RichTextSpanStyle = .link(link)
            var applyRange: NSRange?
            if textView.hasSelectedRange {
                applyRange = textView.selectedRange
            }
            textView.setRichTextLink(.link(link))
            if let applyRange {
                textView.setRichTextLink(style, at: applyRange)
            } else {
                textView.setRichTextLink(style)
            }
        }

        func removeLink() {
            textView.removeRichTextLink(.link())
        }
    }
#endif
