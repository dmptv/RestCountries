//
//  CountryViewModel.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import Foundation
import Combine

class CountryViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var errorMessage: String?

    func loadCountries() {
        APIService.shared.fetchCountries { [weak self] result in
            switch result {
            case .success(let countries):
                DispatchQueue.main.async {
                    print(countries.first)
                    self?.countries = countries
                }
            case .failure(let error ):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
