//
//  ContentView.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(DependencyContainer.self) var container: DependencyContainer

    var body: some View {
        TabView {
            CountryListView()
                .environment(CountryViewModel(
                        countryUseCase: container.resolve(CountryUseCasesProtocol.self)!
                    ))
                .tabItem {
                    Label("Countries", systemImage: "globe")
                }

            HelloWorldView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

            CountriesMap()
                .tabItem {
                    Label("Map", systemImage: "globe.americas.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
