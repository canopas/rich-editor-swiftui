//
//  JsonUtils.swift
//  RichEditorDemo
//
//  Created by Divyesh Vekariya on 05/01/24.
//

import Foundation


internal func readJSONFromFile<T: Decodable>(fileName: String, type: T.Type, bundle: Bundle? = nil) -> T? {
    if let url = (bundle ?? Bundle.main).url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(T.self, from: data)
            return jsonData
        } catch {
            print("JSONUtils: error - \(error)")
        }
    }
    return nil
}


internal class RichBundleFakeClass {}

internal extension Bundle {
    static var richBundle: Bundle {
        return Bundle(for: RichBundleFakeClass.self)
    }
}
