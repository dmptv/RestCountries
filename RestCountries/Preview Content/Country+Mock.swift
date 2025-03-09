//
//  Country+Mock.swift
//  RestCountries
//
//  Created by Kanat on 09.03.2025.
//

import Foundation

extension Country {
    static func preview() async -> Self? {
        if let imgUrl = await ImageURLCache.shared.getURLString(forImageName: "th") {
            return .init(
                name: .init(common: "Thailand"),
                capital: ["Bangkok"],
                region: "South Asia",
                flags: .init(png: imgUrl))
        }
        return nil
    }
}
