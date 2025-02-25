//
//  CountryListView.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI
import Kingfisher

struct CountryListView: View {
    @State var viewModel = CountryViewModel()
    @State private var dataLoaded = false

    var body: some View {
        NavigationStack() {
            VStack {
                if viewModel.isLoading {
                    ProgressView() 
                }

                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                }

                List(viewModel.countries) { country in
                    NavigationLink(value: country) {
                        HStack {
                            KFImage(URL(string: country.flags.png))
                                .loadDiskFileSynchronously()
                                .cacheMemoryOnly()
                                .renderingMode(.original)
                                .placeholder { ProgressView() }
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 30)

                            VStack(alignment: .leading) {
                                Text(country.name.common)
                                    .font(.headline)
                                Text("Capital: \(String(describing: country.capital?.first))")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                .navigationDestination(for: Country.self) { country in
                    CountryDetailView(country: country)
                }
                .navigationDestination(for: String.self) { _ in
                    Text("Ana")
                }
            }
            .navigationTitle("Countries")
            .task {
                if !dataLoaded {
                    viewModel.loadCountries()
                    dataLoaded = true
                }
            }

        }
    }
}

#Preview {
    CountryListView()
}
