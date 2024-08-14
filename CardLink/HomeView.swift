//
//  HomeView.swift
//  CardLink
//
//  Created by Sahil Ak on 05/08/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var cards: [BusinessCard] = [.mock]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    searchBar
                }
                
                ForEach(cards) { card in
                    BusinessCardView(card: card)
                }
            }
            .foregroundStyle(.primaryText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("CardLink")
                        .font(.appTitle3)
                        .foregroundColor(.primaryText)
                }
            }
        }
        
    }
    
    private var searchBar: some View {
        HStack {
            TextField("Search", text: $searchText)
                .textFieldStyle(.plain)
            
            if !searchText.isEmpty {
                Image(systemName: "xmark.circle")
                    .font(.appBody)
                    .contentShape(Rectangle())
                    .frame(width: 44, alignment: .trailing)
                    .onTapGesture {
                        withAnimation(.default) {
                            searchText = ""
                        }
                    }
            }
        }
        .font(.body)
        .tint(.primaryText)
        .accessibilityAddTraits(.isSearchField)
    }
}

#Preview {
    HomeView()
}
