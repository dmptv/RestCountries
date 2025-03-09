//
//  ContentView.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel: CountryViewModel = CountryViewModel(countryUseCase: CountryUseCase())

    var body: some View {
        TabView {
            CountryListView()
                .environment(viewModel)
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
