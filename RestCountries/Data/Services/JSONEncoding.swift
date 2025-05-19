//
//  JSONEncoding.swift
//  RestCountries
//
//  Created by Kanat on 19.05.2025.
//

import Foundation

protocol JSONEncoding {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

extension JSONEncoder: JSONEncoding {}
