//
//  Country.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import Foundation

struct Country: Codable, Identifiable, Hashable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    let name: Name
    let capital: [String]?
    let region: String?
    let flags: Flags
    var isFavorite: Bool = false

    struct Name: Codable, Hashable {
        let common: String
    }

    struct Flags: Codable, Hashable {
        let png: String
    }

    enum CodingKeys: String, CodingKey {
        case name, flags, capital, region
    }
}


