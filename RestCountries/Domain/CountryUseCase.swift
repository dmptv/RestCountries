//
//  CountryUseCase.swift
//  RestCountries
//
//  Created by Kanat on 06.03.2025.
//

import Foundation

protocol CountryUseCasesProtocol: Sendable {
    func loadCountries() async throws -> [Country]
    func saveCountries(_ countries: [Country]) async throws
    func filterCountries(by searchText: String, selectedRegion: String?, from countries: [Country]) async -> [Country]
}

final class CountryUseCase: CountryUseCasesProtocol {
    private let countryService: CountryServiceProtocol
    private let countryRepository: CountryRepositoryProtocol

    init(countryRepository: CountryRepositoryProtocol = CountryRepository(), countryService: CountryServiceProtocol = APIService.shared) {
        self.countryRepository = countryRepository
        self.countryService = countryService
    }

    func loadCountries() async throws -> [Country] {
        if let cached = try await countryRepository.load(), !cached.isEmpty {
            return cached
        }
        let fetched = try await countryService.fetchCountries()
        try await countryRepository.save(fetched)
        return fetched
    }

    func saveCountries(_ countries: [Country]) async throws  {
        try await countryRepository.save(countries)
    }

    func filterCountries(by searchText: String, selectedRegion: String?, from countries: [Country]) async -> [Country] {
        if searchText.isEmpty && selectedRegion == nil {
            return countries
        }

        return countries.filter { country in
            let matchesSearch: Bool = searchText.isEmpty || country.name.common.lowercased().contains(searchText.lowercased())
            let matchesRegion: Bool = (selectedRegion == nil) || country.region == selectedRegion

            return matchesSearch && matchesRegion
        }
    }
}

