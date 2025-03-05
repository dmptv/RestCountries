//
//  APIService.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import Foundation

protocol CountryServiceProtocol {
    func fetchCountries() async throws -> [Country]
}

class APIService: CountryServiceProtocol {
    static var shared = APIService()
    var decoder: JSONDecoding = JSONDecoder()

    private init(decoder: JSONDecoding = JSONDecoder()) {
        self.decoder = decoder
    }

    // Static function to create a shared instance with a custom decoder
    static func configure(with decoder: JSONDecoding) {
        shared = APIService(decoder: decoder)
    }

    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: "https://restcountries.com/v3.1/all") else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.networkError(
                NSError(domain: "HTTP Error",
                        code: (response as? HTTPURLResponse)?.statusCode ?? 500,
                        userInfo: nil)
            )
        }

        return try decoder.decode([Country].self, from: data)
    }
}


