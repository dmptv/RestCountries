//
//  CountryListView.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI

struct CountryListView: View {
    @StateObject var viewModel = CountryViewModel()
    @State var isError = false

    var body: some View {
        NavigationStack() {
            VStack {
                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                }

                List(viewModel.countries) { country in
                    NavigationLink(value: country) {
                        HStack {
                            AsyncImage(url: URL(string: country.flags.png)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
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
            .onAppear {
                viewModel.loadCountries()
            }

        }
    }
}

#Preview {
    CountryListView()
}
