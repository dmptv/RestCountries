//
//  Country+Mock.swift
//  RestCountries
//
//  Created by Kanat on 09.03.2025.
//

import Foundation

extension Country {
    static func preview(_ name: String = "th") async -> Self? {
        if let imgUrl = await ImageURLCache.shared.getURLString(forImageName: name) {
            return .init(
                name: .init(common: "Thailand"),
                capital: ["Bangkok"],
                region: "South Asia",
                flags: .init(png: imgUrl))
        }
        return nil
    }
}
