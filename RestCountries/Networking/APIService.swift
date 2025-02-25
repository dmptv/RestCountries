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

    func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        guard let url = URL(string: "https://restcountries.com/v3.1/all") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(APIError.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.networkError(NSError(domain: "HTTP Error", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil))))
                return
            }

            guard let data else {
                completion(.failure(APIError.noData))
                return
            }

            if let str = String(data: data, encoding: .utf8) {
                print("Successfully decoded")
            }

            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                completion(.success(countries))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
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
