//
//  CountryDetailView.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            AsyncImage(url: URL(string: country.flags.png)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: 200)
            }

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
        .background(content: {
            Color.green.opacity(0.4)
                .ignoresSafeArea()
        })
    }
}

#Preview {
    CountryDetailView(country: .init(name: .init(common: "Thailand"), capital: ["Bangkok"], region: "South Asia", flags: .init(png: "https://mainfacts.com/media/images/coats_of_arms/th.png")))
}
