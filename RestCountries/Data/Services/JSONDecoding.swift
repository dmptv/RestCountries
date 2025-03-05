//
//  JSONDecoding.swift
//  RestCountries
//
//  Created by Kanat on 05.03.2025.
//

import Foundation

protocol JSONDecoding {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: JSONDecoding {}
