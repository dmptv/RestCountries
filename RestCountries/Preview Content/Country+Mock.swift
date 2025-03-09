//
//  Country+Mock.swift
//  RestCountries
//
//  Created by Kanat on 09.03.2025.
//

import Foundation

extension Country {
    static var preview: Self = .init(
        name: .init(common: "Thailand"),
        capital: ["Bangkok"],
        region: "South Asia",
        flags: .init(png: ImageURLCache.shared.getURLString(forImageName: "th")))
}
