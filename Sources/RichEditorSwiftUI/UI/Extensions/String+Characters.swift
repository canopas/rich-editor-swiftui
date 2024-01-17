//
//  String+Characters.swift
//
//
//  Created by Divyesh Vekariya on 01/01/24.
//

import Foundation

public extension String.Element {
    
    /// Get the string element for a `\r` carriage return.
    static var carriageReturn: String.Element { "\r" }
    
    /// Get the string element for a `\n` newline.
    static var newLine: String.Element { "\n" }
    
    /// Get the string element for a `\t` tab.
    static var tab: String.Element { "\t" }
    
    /// Get the string element for a ` ` space.
    static var space: String.Element { " " }
}

public extension String {
    
    /// Get the string for a `\r` carriage return.
    static let carriageReturn = String(.carriageReturn)
    
    /// Get the string for a `\n` newline.
    static let newLine = String(.newLine)
    
    /// Get the string for a `\t` tab.
    static let tab = String(.tab)
    
    /// Get the string for a ` ` space.
    static let space = String(.space)
}
