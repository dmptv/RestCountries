//
//  CountryLoadingUseCase.swift
//  RestCountries
//
//  Created by Kanat on 06.03.2025.
//

import Foundation

protocol CountryLoadingUseCase {
    func loadCountries() async throws -> [Country]
}

struct DefaultCountryLoadingUseCase: CountryLoadingUseCase {
    private let countryRepository: CountryRepositoryProtocol
    private let countryService: CountryServiceProtocol

    init(countryRepository: CountryRepositoryProtocol, countryService: CountryServiceProtocol) {
        self.countryRepository = countryRepository
        self.countryService = countryService
    }

    func loadCountries() async throws -> [Country] {
        if let savedCountries = countryRepository.loadCountries(), !savedCountries.isEmpty {
            return savedCountries
        }
        let fetchedCountries = try await countryService.fetchCountries()
        countryRepository.saveCountries(fetchedCountries)
        return fetchedCountries
    }
}
