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
    private var countries: [Country] = []
    var errorMessage: String?
    var isLoading = false
    private let countryService: CountryServiceProtocol
    private let countryRepository: CountryRepositoryProtocol

    var regions: [String] {
            let uniqueRegions = Set(countries.compactMap { $0.region })
            return ["All"] + uniqueRegions.sorted()
        }

    var searchQuery: String = "" {
        didSet {
            applyFilters()
        }
    }

    var selectedRegion: String? = nil {
        didSet {
            applyFilters()
        }
    }

    var filteredCountries: [Country] = []

    private func applyFilters() {
        filteredCountries = countries.filter { country in
            let matchesSearch = searchQuery.isEmpty || country.name.common.lowercased().contains(searchQuery.lowercased())
            let matchesRegion = selectedRegion == nil || country.region == selectedRegion
            return matchesSearch && matchesRegion
        }
    }

    init(countryService: CountryServiceProtocol, countryRepository: CountryRepositoryProtocol = CountryRepository()) {
        self.countryService = countryService
        self.countryRepository = countryRepository
        let decodedCountries = self.countryRepository.loadCountries()
        countries = decodedCountries ?? []
        filteredCountries = decodedCountries ?? []
    }

    func loadCountries() {
        if !countries.isEmpty { return }

        isLoading = true

        Task {
            do {
                let fetchedCountries = try await APIService.shared.fetchCountries()
                await MainActor.run {
                    countries = fetchedCountries
                    filteredCountries = fetchedCountries
                    isLoading = false
                    countryRepository.saveCountries(fetchedCountries)
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

/*
 class CountriesViewModel: ObservableObject {
     @Published var countries: [Country] = []
     @Published var filteredCountries: [Country] = []
     @Published var isLoading = false
     @Published var errorMessage: String?

     private let loadingUseCase: CountryLoadingUseCase
     private let savingUseCase: CountrySavingUseCase
     private let filteringUseCase: CountryFilteringUseCase

     init(
         loadingUseCase: CountryLoadingUseCase,
         savingUseCase: CountrySavingUseCase,
         filteringUseCase: CountryFilteringUseCase
     ) {
         self.loadingUseCase = loadingUseCase
         self.savingUseCase = savingUseCase
         self.filteringUseCase = filteringUseCase
     }

     func loadCountries() {
         if !countries.isEmpty { return }

         isLoading = true

         Task {
             do {
                 let fetchedCountries = try await loadingUseCase.loadCountries()
                 await MainActor.run {
                     countries = fetchedCountries
                     filteredCountries = fetchedCountries
                     isLoading = false
                 }
             } catch {
                 await MainActor.run {
                     errorMessage = error.localizedDescription
                     isLoading = false
                 }
             }
         }
     }

     func filterCountries(by searchText: String) {
         filteredCountries = filterCountries(
         by: searchQuery,
         selectedRegion: selectedRegion,
         from: countries
         )
     }
 }
 */
