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
        VStack {
            AsyncImage(url: URL(string: country.flags.png)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }

            Text(country.name.common)
                .font(.largeTitle)
                .bold()
            Group {
                Text("Capital: \(country.capital.first ?? "N/A")")
                Text("Region: \(country.region)")
                Text("Population: \(country.population)")
                Text("Area: \(country.area ?? 0) km²")
            }
            .font(.title3)
        }
    }
}

#Preview {
    CountryDetailView(country:
            .init(name: .init(common: "Thailand"),
                  capital: ["Bangkok"],
                  flags: .init(png: "https://flagcdn.com/w320/cy.png"),
                  region: "South Asia",
                  population: 100000,
                  area: 40000.00))
}
