//
//  ContentView.swift
//  RestCountries
//
//  Created by Kanat on 23.02.2025.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel: CountryViewModel = CountryViewModel(countryService: APIService.shared)

    var body: some View {
        CountryListView()
            .environment(viewModel)
    }
}

#Preview {
    ContentView()
}
