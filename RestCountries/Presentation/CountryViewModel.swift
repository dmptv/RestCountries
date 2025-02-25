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
    var countries: [Country] = []
    var errorMessage: String?
    var isLoading = false
    private var cachedCountries: [Country]?

    func loadCountries() {
        if let cachedCountries = cachedCountries {
            self.countries = cachedCountries
        }

        isLoading = true

        Task {
            do {
                let fetchedCountries = try await APIService.shared.fetchCountries()
                await MainActor.run {
                    self.cachedCountries = fetchedCountries
                    self.countries = fetchedCountries
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
