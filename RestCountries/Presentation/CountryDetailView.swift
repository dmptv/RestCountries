//
//  CountryDetailView.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI
import Kingfisher

struct CountryDetailView: View {
    let country: Country

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            KFImage(URL(string: country.flags.png))
                .loadDiskFileSynchronously()
                .cacheMemoryOnly()
                .renderingMode(.original)
                .placeholder {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                }
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(country.name.common)
                    .font(.largeTitle)
                    .bold()

                Group {
                    Text("Capital: \(country.capital?.first ?? "N/A")")
                    if let region = country.region {
                        Text("Region: \(String(describing: region))")
                    }
                }
                .font(.title3)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .navigationTitle(country.capital?.first ?? "")
        .background(
            Color.green.opacity(0.4)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    CountryDetailView_Preview()
}

private struct CountryDetailView_Preview: View {
    @State var country: Country? = nil

    var body: some View {
        VStack {
            if let country = country {
                CountryDetailView(country: country)
            } else {
                ProgressView()
            }
        }
        .task {
            country = await Country.preview()
        }
    }
}

