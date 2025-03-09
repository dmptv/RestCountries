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
    private var countries: [Country] = []
    private var filterTask: Task<Void, Never>?

    var regions: [String] {
        let uniqueRegions = Set(countries.compactMap { $0.region })
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
            Task {
                filterTask?.cancel()
                filterTask = Task {
                    await applyFilters()
                }
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
                let fetchedCountries = try await countryUseCase.loadCountries()

                if fetchedCountries != countries {
                    await MainActor.run {
                        countries = fetchedCountries
                        filteredCountries = fetchedCountries
                    }

                    Task.detached(priority: .background) { [weak self] in
                        do {
                            try await self?.countryUseCase.saveCountries(fetchedCountries)
                        } catch {
                            print("Error saving countries: \(error)")
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                }
            }

            await MainActor.run {
                isLoading = false
            }
        }
    }

    func toggleFavorite(country: Country) {
        if let index = countries.firstIndex(where: { $0.id == country.id }) {
            var processedCountry = countries[index]
            processedCountry.isFavorite.toggle()
            countries[index] = processedCountry
            filteredCountries[index] = processedCountry
        }
    }

    private func applyFilters() async {
        filteredCountries = await countryUseCase
            .filterCountries(by: searchQuery,
                             selectedRegion: selectedRegion,
                             from: countries)
    }
}

