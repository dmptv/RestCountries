//
//  APIService.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import Foundation

class APIService {
    static let shared = APIService()

    private init() {}

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

        return try JSONDecoder().decode([Country].self, from: data)
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode data"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
