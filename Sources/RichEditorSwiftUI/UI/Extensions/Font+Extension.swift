//
//  Font+Extension.swift
//
//
//  Created by Divyesh Vekariya on 18/10/23.
//

import UIKit

extension UIFont {
    var isBold: Bool {
        return self.fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return self.fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}
