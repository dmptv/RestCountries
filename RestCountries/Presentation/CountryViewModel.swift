//
//  CountryViewModel.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI

@MainActor
@Observable
final class CountryViewModel {
    var countries: [Country] = []
    var errorMessage: String?
    var isLoading = false
    private let countryService: CountryServiceProtocol
    private let fileName = "cached_countries.json"

    init(countryService: CountryServiceProtocol) { 
        self.countryService = countryService
        loadFromStorage()
    }

    // MARK: - File Storage Methods
    private func loadFromStorage() {
        guard let filePath = getFilePath(), FileManager.default.fileExists(atPath: filePath.path) else { return }
        let decoder = JSONDecoder()

        do {
            let data = try Data(contentsOf: filePath)
            let decodedCountries = try decoder.decode([Country].self, from: data)
            self.countries = decodedCountries
        } catch {
            print("Failed to load countries: \(error.localizedDescription)")
        }
    }

    private func getFilePath() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first?.appendingPathComponent(fileName)
    }

    private func saveToStorage(countries: [Country]) {
        guard let filePath = getFilePath() else { return }
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(countries)
            try data.write(to: filePath)
        } catch {
            print("Failed to save countries: \(error.localizedDescription)")
        }
    }

    // MARK: - Data Fetched Remotely
    func loadCountries() {
        if !countries.isEmpty { return }

        isLoading = true

        Task {
            do {
                let fetchedCountries = try await APIService.shared.fetchCountries()
                await MainActor.run {
                    countries = fetchedCountries
                    isLoading = false
                    saveToStorage(countries: fetchedCountries)
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}
