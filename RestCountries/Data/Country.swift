//
//  Country.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import Foundation

struct Country: Codable, Identifiable {
    var id = UUID()
    let name: Name
    let capital: [String]?
    let region: String?
    let flags: Flags

    struct Name: Codable {
        let common: String
    }

    struct Flags: Codable {
        let png: String
    }

    enum CodingKeys: String, CodingKey {
        case name, flags, capital, region
    }
}


