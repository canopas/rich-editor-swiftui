// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit
import SwiftUI

public struct RichEditorView: View {
    
    
    @Binding var text: NSMutableAttributedString
    @State var typingAtributes: [NSAttributedString.Key: Any]? = [:]
    @State var appliedTools: [EditorTool] = []
    @State var selectedRange: NSRange? = nil
    
    private let isEditable: Bool
    private let isUserInteractionEnabled: Bool
    private let isScrollEnabled: Bool
    private let linelimit: Int?
    private let fontStyle: UIFont?
    private let fontColor: Color
    private let backGroundColor: UIColor
    private let tag: Int?
    private let onTextViewEvent: ((TextViewEvents) -> Void)?
    
    public init(text: Binding<NSMutableAttributedString>,
                //typingAttributes: Binding<[NSAttributedString.Key : Any]?>? = nil,
                appliedTools: [EditorTool] = [],
                isEditable: Bool = true,
                isUserInteractionEnabled: Bool = true,
                isScrollEnabled: Bool = false,
                linelimit: Int? = nil,
                fontStyle: UIFont? = nil,
                fontColor: Color = .black,
                backGroundColor: UIColor = .clear,
                tag: Int? = nil,
                onTextViewEvent: ((TextViewEvents) -> Void)? = nil) {
        self._text = text
//        self._typingAttributes = typingAttributes != nil ? typingAttributes! : .constant(nil)
        
        self.appliedTools = appliedTools
        self.isEditable = isEditable
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.isScrollEnabled = isScrollEnabled
        self.linelimit = linelimit
        self.fontStyle = fontStyle
        self.fontColor = fontColor
        self.backGroundColor = backGroundColor
        self.tag = tag
        self.onTextViewEvent = onTextViewEvent
    }
    
    public var body: some View {
        VStack {
            EditorToolBarView(appliedTools: appliedTools, onToolSelect: onToolSelect(_:))
            
            TextViewWrapper(text: $text, selectedRange: $selectedRange, typingAttributes: $typingAtributes, fontStyle: .systemFont(ofSize: 20), onTextViewEvent: onTextViewEvent(_:))
        }
    }
    
    func onTextViewEvent(_ event: TextViewEvents) -> Void {
        switch event {
        case .changeSelection(let textView):
            selectedRange = textView.selectedRange
//            setTypingAttributes()
        case .beginEditing:
            setTypingAttributes()
            return
        case .change:
            return
        case .EndEditing:
            return
        }
        //Call Back passed to parent if neened
        onTextViewEvent?(event)
    }
    
    func onToolSelect(_ tool: EditorTool) -> Void {
        if appliedTools.contains(where: { $0 == tool }) {
            appliedTools.removeAll(where: { $0 == tool })
        } else {
            appliedTools.append(tool)
        }
        
        if let selectedRange = selectedRange {
            switch tool {
            case .title:
                text.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .title1), range: selectedRange)
            case .bold:
                addBoldAtribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: selectedRange)
            case .italic:
                text.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 20), range: selectedRange)
            case .underline:
                text.addAttribute(.underlineStyle, value: 1, range: selectedRange)
            case .photo:
                // add photo
                return
            case .video:
                // add video
                return
            }
        }
    }
    
    func addBoldAtribute(_ name: NSAttributedString.Key, value: Any, range: NSRange? = nil) {
        if let range = range, range.lowerBound < range.upperBound {
            //Enumerate all the fonts in the selectedRange
            text.enumerateAttribute(.font, in: range, options: []) { (font, range, pointee) in
                let newFont: UIFont
                if let font = font as? UIFont {
                    if font.fontDescriptor.symbolicTraits.contains(.traitBold) { //Was bold => Regular
                        newFont = UIFont.systemFont(ofSize: font.pointSize, weight: .regular)
                    } else { //Wasn't bold => Bold
                        newFont = UIFont.systemFont(ofSize: font.pointSize, weight: .bold)
                    }
                } else { //No font was found => Bold
                    newFont = UIFont.systemFont(ofSize: 17, weight: .bold) //Default bold
                }
                text.addAttributes([.font : newFont], range: range)
            }
        } else {
            if appliedTools.contains(where: { $0 == .bold }) {
                typingAtributes?[.font] = UIFont.systemFont(ofSize: 17, weight: .bold)
            } else {
                typingAtributes?.removeValue(forKey: .font)
            }
        }
    }
    
    func setTypingAttributes() {
        if let selectedRange = selectedRange {
            if selectedRange.lowerBound == text.length {
                // set same attributes as last item have
                text.enumerateAttributes(in: selectedRange, options: .longestEffectiveRangeNotRequired) { (attributes, range, stop) in
                    typingAtributes = attributes
                }
            }
        }
    }
}
