//
//  RestCountriesApp.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI


@main
struct RestCountriesApp: App {
    private var container = DependencyContainer()

    init() {
        container.register(CountryRepository(), for: CountryRepositoryProtocol.self)
        container.register(APIService.shared, for: CountryServiceProtocol.self)
        container.register(
            CountryUseCase(
                countryRepository: container.resolve(CountryRepositoryProtocol.self)!,
                countryService: container.resolve(CountryServiceProtocol.self)!
            ),
            for: CountryUseCasesProtocol.self
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(container)
        }
    }
}

