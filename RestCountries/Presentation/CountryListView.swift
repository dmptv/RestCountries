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
        NavigationView {
            VStack {
                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                }

                List(viewModel.countries) { country in
                    NavigationLink(destination: CountryDetailView(country: country)) {
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
            }
            .onAppear {
                viewModel.loadCountries()
            }

        }
        .navigationTitle("Countries")
    }
}

#Preview {
    CountryListView()
}
