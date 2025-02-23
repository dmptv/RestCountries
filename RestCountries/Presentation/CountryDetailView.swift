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
            }
            .font(.title3)
        }
    }
}

#Preview {
    CountryDetailView(country: .init(name: .init(common: "Thailand"), capital: ["Bangkok"], region: "South Asia", flags: .init(png: "https://flagcdn.com/w320/gs.png")))
}
