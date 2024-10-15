//
//  SearchBarView.swift
//  NearMeApp
//
//  Created by Brian Surface on 10/11/24.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var search: String
    @Binding var isSearching: Bool
    
    var body: some View {
        TextField("Search", text: $search)
            .textFieldStyle(.roundedBorder)
            .padding()
            .onSubmit {
                isSearching = true
            }
        SearchOptionsView{ searchItem in
            search = searchItem
            isSearching = true
            
        }
    }
}

#Preview {
    SearchBarView(search: .constant("coffee"), isSearching: .constant(true))
}
