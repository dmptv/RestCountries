//
//  CountryFilteringUseCase.swift
//  RestCountries
//
//  Created by Kanat on 06.03.2025.
//

import Foundation

protocol CountryFilteringUseCase {
    func filterCountries(by searchText: String, selectedRegion: String?, from countries: [Country]) -> [Country]
}

struct DefaultCountryFilteringUseCase: CountryFilteringUseCase {
    func filterCountries(by searchText: String, selectedRegion: String?, from countries: [Country]) -> [Country] {
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
