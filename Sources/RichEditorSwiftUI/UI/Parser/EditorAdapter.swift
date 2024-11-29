//
//  EditorAdapter.swift
//
//
//  Created by Divyesh Vekariya on 11/12/23.
//

import Foundation
protocol EditorAdapter {
    func encodeToString<T: Encodable>(type model: T) throws -> String?
    func decode<T: Decodable>(from jsonString: String) throws -> T?
    func encode<T: Encodable>(type model: T) throws -> Data
}

class DefaultAdapter: EditorAdapter {
    func encodeToString<T: Encodable>(type model: T) throws -> String? {
        do {
            let jsonData = try JSONEncoder().encode(model)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            throw error
        }
    }

    func decode<T: Decodable>(from jsonString: String) throws -> T? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        do {
            let content = try JSONDecoder().decode(T.self, from: data)
            return content
        } catch {
            throw error
        }
    }

    func encode<T>(type model: T) throws -> Data where T : Encodable {
         return try JSONEncoder().encode(model)
    }
}
