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
    private let countryUseCase: CountryUseCasesProtocol
    private var _countries: [Country] = []
    private var filterTask: Task<Void, Never>?

    var regions: [String] {
        let uniqueRegions = Set(_countries.compactMap { $0.region })
        return ["All"] + uniqueRegions.sorted()
    }

    var filteredCountries: [Country] = []
    var isLoading = false
    var errorMessage: String?

    var searchQuery: String = "" {
        didSet {
            filterTask?.cancel()
            filterTask = Task {
                await applyFilters()
            }
        }
    }

    var selectedRegion: String? = nil {
        didSet {
            filterTask?.cancel()
            filterTask = Task {
                await applyFilters()
            }
        }
    }

    init(
        countryUseCase: CountryUseCasesProtocol
    ) {
        self.countryUseCase = countryUseCase
    }

    func loadCountries() {
        isLoading = true

        Task {
            do {
                let countries: [Country] = try await countryUseCase.loadCountries()

                if countries != _countries {
                    _countries = countries
                    filteredCountries = countries
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func toggleFavorite(country: Country) {
        if let index = _countries.firstIndex(where: { $0.id == country.id }) {
            var processedCountry = _countries[index]
            processedCountry.isFavorite.toggle()
            _countries[index] = processedCountry
            filteredCountries[index] = processedCountry
        }
    }

    private func applyFilters() async {
        filteredCountries = await countryUseCase
            .filterCountries(by: searchQuery,
                             selectedRegion: selectedRegion,
                             from: _countries)
    }
}
