//
//  CountryListView.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI
import Kingfisher

struct CountryListView: View {
    @Environment(CountryViewModel.self) var viewModel: CountryViewModel
    @State private var dataLoaded = false

    var body: some View {
        NavigationStack() {
            VStack {
                Picker("Select Region", selection: Binding(
                    get: { viewModel.selectedRegion ?? "All" },
                    set: { newValue in viewModel.selectedRegion = newValue == "All" ? nil : newValue }
                )) {
                    ForEach(viewModel.regions, id: \.self) { region in
                        Text(region).tag(region)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 8)

                if viewModel.isLoading {
                    ProgressView() 
                }

                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                }

                List(viewModel.filteredCountries) { country in
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
                                Spacer()
                                Image(systemName: country.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        viewModel.toggleFavorite(country: country)
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .searchable(text: Binding(
                    get: { viewModel.searchQuery },
                    set: { newValue in viewModel.searchQuery = newValue }
                ), prompt: Text("Search for a country"))
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
        .environment(CountryViewModel(countryUseCase: CountryUseCase()))
}
