//
//  CountryRepository.swift
//  RestCountries
//
//  Created by Kanat on 25.02.2025.
//

import Foundation

protocol CountryRepositoryProtocol: Sendable {
    func load() async throws -> [Country]?
    func save(_ countries: [Country]) async throws
}

actor CountryRepository: CountryRepositoryProtocol {
    private let fileName = "countries.json"
    private let decoder: JSONDecoding
    private let encoder: JSONEncoding

    init(decoder: JSONDecoding = JSONDecoder(), encoder: JSONEncoding = JSONEncoder()) {
        self.decoder = decoder
        self.encoder = encoder
    }

    func load() async throws -> [Country]? {
        let url = try getFilePath()
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return try decoder.decode([Country].self, from: data)
    }

    func save(_ countries: [Country]) async throws {
        let url = try getFilePath()
        let data = try encoder.encode(countries)
        try data.write(to: url)
    }

    private func getFilePath() throws -> URL {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "FileError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No file path found"])
        }
        return dir.appendingPathComponent(fileName)
    }
}
