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
    @State var errorMessage: String?
    
    var body: some View {
        NavigationStack() {
            VStack {
                pickerView
                .padding(.horizontal, 8)
                statesView
                countriesList
            }
            .navigationTitle("Countries")
            .task {
                let result = await viewModel.loadCountries()
                if case .failure(let error) = result {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private var countriesList: some View {
        List(viewModel.filteredCountries) { country in
            NavigationLink(value: country) {
                HStack {
                    countryImage(country)
                    countryDescription(country)
                }
            }
            .padding(.vertical, 4)
        }
        .searchable(text: searchBinding, prompt: Text("Search for a country"))
        .navigationDestination(for: Country.self) { country in
            CountryDetailView(country: country)
        }
        .navigationDestination(for: String.self) { _ in
            Text("Ana")
        }
    }

    private func countryDescription(_ country: Country) -> some View {
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

    private func countryImage(_ country: Country) -> some View {
        KFImage(URL(string: country.flags.png))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .renderingMode(.original)
            .placeholder { ProgressView() }
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 30)
    }

    private var statesView: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            }

            if let error = errorMessage {
                Text("Error: \(error)")
            }
        }
    }

    private var pickerView: some View {
        Picker("Select Region", selection: regionBinding) {
            ForEach(viewModel.regions, id: \.self) { region in
                Text(region)
                    .tag(region)
            }
        }
        .pickerStyle(.segmented)
    }

    private var regionBinding: Binding<String> {
        Binding(
            get: { viewModel.selectedRegion ?? "All" },
            set: { newValue in
                viewModel.selectedRegion = (newValue == "All" ? nil : newValue)
            }
        )
    }

    private var searchBinding: Binding<String> {
        Binding(
            get: { viewModel.searchQuery },
            set: { newValue in viewModel.searchQuery = newValue }
        )
    }
}

#Preview {
    CountryListView()
        .environment(CountryViewModel(countryUseCase: CountryUseCase()))
}
