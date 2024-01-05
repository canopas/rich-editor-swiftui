//
//  SpanProvider.swift
//
//
//  Created by Divyesh Vekariya on 26/12/23.
//

import SwiftUI

internal class SpanProvider {
    
    func getSpansFromAttributedText(_ text: NSMutableAttributedString, forRange range: NSRange? = nil, forStyles styles: [TextSpanStyle] = TextSpanStyle.allCases) -> [RichTextSpan] {
        var spans: [RichTextSpan] = []
        styles.forEach({ style in
            switch style {
            case .bold:
                spans.append(contentsOf: getSpanForBold(text, forRange: range))
            case .italic:
                spans.append(contentsOf: getSpanForItalic(text, forRange: range))
            case .underline:
                spans.append(contentsOf: [])
            case .h1:
                spans.append(contentsOf: [])
            case .h2:
                spans.append(contentsOf: [])
            case .h3:
                spans.append(contentsOf: [])
            case .h4:
                spans.append(contentsOf: [])
            case .h5:
                spans.append(contentsOf: [])
            case .h6:
                spans.append(contentsOf: [])
            default:
                print("match not found")
            }
        })
        
        return spans
    }
    
    func getSpanForBold(_ text: NSMutableAttributedString, forRange range: NSRange? = nil) -> [RichTextSpan] {
        var spans: [RichTextSpan] = []
        text.enumerateAttribute(.font, in: range == nil ? NSRange(location: 0, length: text.length) : range!, options: []) { (value, range, _) in
            if let font = value as? UIFont {
                if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    spans.append(RichTextSpan(from: range.location, to: range.location + range.length, style: .bold))
                }
            } else {
                print("===== not able to cast in uifont for style \(TextSpanStyle.bold)")
            }
        }
        return spans
    }
    
    func getSpanForItalic(_ text: NSMutableAttributedString, forRange range: NSRange? = nil) -> [RichTextSpan] {
        var spans: [RichTextSpan] = []
        text.enumerateAttribute(.font, in: range == nil ? NSRange(location: 0, length: text.length) : range!, options: []) { (value, range, _) in
            if let font = value as? UIFont {
                if font.fontDescriptor.symbolicTraits.contains(.traitItalic) {
                    spans.append(RichTextSpan(from: range.location, to: range.location + range.length, style: .italic))
                }
            } else {
                print("===== not able to cast in uifont for style \(TextSpanStyle.italic)")
            }
        }
        return spans
    }
}
