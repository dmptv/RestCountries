//
//  Country.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import Foundation

struct Country: Identifiable, Decodable {
    var id = UUID()
    let name: Name
    let capital: [String]
    let flags: Flags
    let region: String
    let population: Int
    let area: Double?

    struct Name: Decodable {
        let common: String
    }

    struct Flags: Decodable {
        let png: String
    }

}
