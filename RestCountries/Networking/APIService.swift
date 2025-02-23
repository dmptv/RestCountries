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
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else {
                completion(.failure(NSError(domain: "No Data", code: 404)))
                return
            }

            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(countries))
                }
            } catch {
                completion(.failure(error))
            }
        }
        .resume()

    }
}
