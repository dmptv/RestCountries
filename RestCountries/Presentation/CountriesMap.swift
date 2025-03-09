//
//  CountriesMap.swift
//  RestCountries
//
//  Created by Kanat on 09.03.2025.
//

import SwiftUI

/*
 Regional Groups View

 Purpose: Group countries by region (e.g., Africa, Americas, Asia, Europe, Oceania) and display them in a categorized list or a map with markers.
 Content:
 List of regions with expandable sections for countries
 Map with markers for countries, color-coded by region
 Implementation:
 Group the countries by region in the CountryViewModel.
 Use a List with sections or a Map with custom annotations.
 */

struct CountriesMap: View {
    var body: some View {
        Text("Hello, World!")
            .navigationTitle("Map")
    }
}

#Preview {
    CountriesMap()
}
