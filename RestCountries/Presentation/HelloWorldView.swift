//
//  HelloWorldView.swift
//  RestCountries
//
//  Created by Kanat on 09.03.2025.
//

import SwiftUI

/*
 3. Favorites View

 Purpose: Allow users to mark countries as favorites and display them in a separate list.
 Content:
 List of favorite countries
 Option to add/remove favorites
 Implementation:
 Add a "favorite" property to the Country model.
 Update the CountryViewModel to manage the list of favorites (e.g., using an array or a Core Data entity).
 */

struct HelloWorldView: View {
    var body: some View {
        NavigationStack()  {
            VStack {
                Text("Hello, World!")
            }
                .navigationTitle("Hello")
        }
    }
}

#Preview {
    HelloWorldView()
}
