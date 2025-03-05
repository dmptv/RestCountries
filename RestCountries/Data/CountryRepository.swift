//
//  CountryRepository.swift
//  RestCountries
//
//  Created by Kanat on 25.02.2025.
//

import Foundation

protocol CountryRepositoryProtocol {
    func loadCountries() -> [Country]?
    func saveCountries(_ countries: [Country])
}

class CountryRepository: CountryRepositoryProtocol {
    private let fileName = "countries.json"
    let decoder: JSONDecoding

    init(decoder: JSONDecoding = JSONDecoder()) {
        self.decoder = decoder
    }

    func loadCountries() -> [Country]? {
        guard let filePath = getFilePath(), FileManager.default.fileExists(atPath: filePath.path) else { return nil }

        do {
            let data = try Data(contentsOf: filePath)
            let decodedCountries = try decoder.decode([Country].self, from: data)
            return decodedCountries
        } catch {
            print("Failed to load countries: \(error.localizedDescription)")
            return nil
        }
    }

    func saveCountries(_ countries: [Country]) {
        guard let filePath = getFilePath() else { return }
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(countries)
            try data.write(to: filePath)
        } catch {
            print("Failed to save countries: \(error.localizedDescription)")
        }
    }

    private func getFilePath() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first?.appendingPathComponent(fileName)
    }
}
