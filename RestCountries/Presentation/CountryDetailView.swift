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
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .center, spacing: 0) {
                AsyncImage(url: URL(string: country.flags.png)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                }
            }
            .frame(width: 50)

            VStack(alignment: .leading, spacing: 4) {
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
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CountryDetailView(country: .init(name: .init(common: "Thailand"), capital: ["Bangkok"], region: "South Asia", flags: .init(png: "https://mainfacts.com/media/images/coats_of_arms/th.png")))
}
