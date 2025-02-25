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

    func loadCountries() {
        Task {
            do {
                self.countries = try await APIService.shared.fetchCountries()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
