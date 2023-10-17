//
//  File.swift
//  
//
//  Created by Divyesh Vekariya on 12/10/23.
//

import UIKit

class TextViewModel: ObservableObject {
    
    @Published var content: String? = nil
    @Published var spans: [Span] = []
    

    init(content: String? = nil, spans: [Span] = []) {
        self.content = content
        self.spans = spans
    }
}
