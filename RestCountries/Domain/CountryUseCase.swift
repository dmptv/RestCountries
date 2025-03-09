//
//  CountryUseCase.swift
//  RestCountries
//
//  Created by Kanat on 06.03.2025.
//

import Foundation

protocol CountryUseCasesProtocol {
    func loadCountries() async throws -> [Country]
    func saveCountries(_ countries: [Country]) async throws
    func filterCountries(by searchText: String, selectedRegion: String?, from countries: [Country]) async -> [Country]
}

class CountryUseCase: CountryUseCasesProtocol {
    private let countryRepository: CountryRepositoryProtocol
    private let countryService: CountryServiceProtocol

    init(countryRepository: CountryRepositoryProtocol = CountryRepository(), countryService: CountryServiceProtocol = APIService.shared) {
        self.countryRepository = countryRepository
        self.countryService = countryService
    }

    func loadCountries() async throws -> [Country] {
        if let savedCountries = countryRepository.loadCountries(), !savedCountries.isEmpty {
            return savedCountries
        }
        let fetchedCountries = try await countryService.fetchCountries()
        return fetchedCountries
    }

    func saveCountries(_ countries: [Country]) async throws  {
        countryRepository.saveCountries(countries)
    }

    func filterCountries(by searchText: String, selectedRegion: String?, from countries: [Country]) async -> [Country] {
        if searchText.isEmpty && selectedRegion == nil {
            return countries
        }

        return countries.filter { country in
            let matchesSearch = searchText.isEmpty || country.name.common.lowercased().contains(searchText.lowercased())
            let matchesRegion = selectedRegion == nil || country.region == selectedRegion
            return matchesSearch && matchesRegion
        }
    }
}

