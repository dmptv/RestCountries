//
//  CountrySavingUseCase.swift
//  RestCountries
//
//  Created by Kanat on 06.03.2025.
//

import Foundation

protocol CountrySavingUseCase {
    func saveCountries(_ countries: [Country])
}

struct DefaultCountrySavingUseCase: CountrySavingUseCase {
    private let countryRepository: CountryRepositoryProtocol

    init(countryRepository: CountryRepositoryProtocol) {
        self.countryRepository = countryRepository
    }

    func saveCountries(_ countries: [Country]) {
        countryRepository.saveCountries(countries)
    }
}
