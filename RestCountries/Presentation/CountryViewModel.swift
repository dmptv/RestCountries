//
//  CountryViewModel.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI


@MainActor
@Observable
class CountryViewModel {
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
        if !countries.isEmpty { return }

        isLoading = true

        Task {
            do {
                let fetchedCountries = try await countryUseCase.loadCountries()

                await MainActor.run {
                    countries = fetchedCountries
                    filteredCountries = fetchedCountries
                    isLoading = false
                }

                Task.detached(priority: .background) { [weak self] in
                    guard let self else { return }
                    do {
                        try await countryUseCase.saveCountries(fetchedCountries)
                    } catch {
                        print("Error saving countries: \(error)")
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }

    private func applyFilters() async {
        filteredCountries = await countryUseCase
            .filterCountries(by: searchQuery,
                             selectedRegion: selectedRegion,
                             from: countries)
    }
}

