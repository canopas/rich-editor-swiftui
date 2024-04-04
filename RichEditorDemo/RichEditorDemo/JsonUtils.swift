//
//  JsonUtils.swift
//  RichEditorDemo
//
//  Created by Divyesh Vekariya on 05/01/24.
//

import Foundation


internal func readJSONFromFile<T: Decodable>(fileName: String,
                                             type: T.Type,
                                             bundle: Bundle? = nil) -> T? {
    if let url = (bundle ?? Bundle.main)
        .url(forResource: fileName, withExtension: "json") {
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


func encode<T: Encodable>(model: T?) throws -> String? {
    guard let model else { return nil }
    do {
        let jsonData = try JSONEncoder().encode(model)
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString
    } catch {
        throw error
    }
}

func decode<T: Decodable>(json string: String) throws -> T? {
    guard let data = string.data(using: .utf8) else { return nil }
    do {
        let content = try JSONDecoder().decode(T.self, from: data)
        return content
    } catch {
        throw error
    }
}
