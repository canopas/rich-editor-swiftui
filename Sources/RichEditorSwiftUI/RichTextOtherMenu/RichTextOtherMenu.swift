//
//  RichTextOtherMenu.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 19/12/24.
//

import SwiftUI

public enum RichTextOtherMenu: String, CaseIterable, Identifiable,
    RichTextLabelValue
{
    case link

}

extension RichTextOtherMenu {

    /// All available rich text styles.
    public static var all: [Self] { allCases }
}

extension Collection where Element == RichTextOtherMenu {

    /// All available rich text styles.
    public static var all: [RichTextOtherMenu] { RichTextOtherMenu.allCases }
}

extension RichTextOtherMenu {

    public var id: String { rawValue }

    /// The standard icon to use for the trait.
    public var icon: Image {
        switch self {
        case .link: .richTextLink
        }
    }

    /// The localized style title.
    public var title: String {
        titleKey.text
    }

    /// The localized style title key.
    public var titleKey: RTEL10n {
        switch self {
        case .link: .link
        }
    }
}

extension Collection where Element == RichTextOtherMenu {

    /// Check if the collection contains a certain style.
    public func hasStyle(_ style: RichTextOtherMenu) -> Bool {
        contains(style)
    }

    /// Check if a certain style change should be applied.
    public func shouldAddOrRemove(
        _ style: RichTextOtherMenu,
        _ newValue: Bool
    ) -> Bool {
        let shouldAdd = newValue && !hasStyle(style)
        let shouldRemove = !newValue && hasStyle(style)
        return shouldAdd || shouldRemove
    }
}

extension RichTextOtherMenu {
    func richTextSpanStyle() -> RichTextSpanStyle {
        switch self {
        case .link: .link()
        }
    }
}
