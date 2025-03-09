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
                    Label("Hello", systemImage: "hand.wave")
                }

            CountriesMap()
                .tabItem {
                    Label("Map", systemImage: "hand.wave")
                }
        }
    }
}

#Preview {
    ContentView()
}
