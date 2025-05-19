//
//  CountryViewModel.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI


@MainActor
protocol CountryViewModelProtocol: AnyObject {
    var filteredCountries: [Country] { get }
    var regions: [String] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var searchQuery: String { get set }
    var selectedRegion: String? { get set }

    func loadCountries()
    func toggleFavorite(country: Country)
}

@MainActor
@Observable
final class CountryViewModel {
    private let countryUseCase: CountryUseCasesProtocol
    private var debounceTask: Task<Void, Never>?

    private var _countries: [Country] = [] {
        didSet {
            filteredCountries = _countries
        }
    }
    private(set) var filteredCountries: [Country] = []


    var regions: [String] {
        let uniqueRegions = Set(_countries.compactMap { $0.region })
        return ["All"] + uniqueRegions.sorted()
    }

    var isLoading = false
    var errorMessage: String?

    var searchQuery: String = "" {
        didSet {
            debounceSearch()
        }
    }

    var selectedRegion: String? {
        didSet { debounceSearch() }
    }

    init(
        countryUseCase: CountryUseCasesProtocol
    ) {
        self.countryUseCase = countryUseCase
    }

    private func debounceSearch() {
        debounceTask?.cancel()

        debounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 300_000_000)
            await self?.applyFilters()
        }
    }

    private func applyFilters() async {
        filteredCountries = await countryUseCase
            .filterCountries(by: searchQuery,
                             selectedRegion: selectedRegion,
                             from: _countries)
    }
}

extension CountryViewModel: CountryViewModelProtocol {

    func loadCountries() {
        defer {  isLoading = false }
        isLoading = true

        Task {
            do {
                let countries = try await countryUseCase.loadCountries()
                _countries = countries
            } catch {
                errorMessage = error.localizedDescription
            }
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
}
