//
//  HomeView.swift
//  CardLink
//
//  Created by Sahil Ak on 05/08/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var cards: [BusinessCard] = [.mock, .init(id: .init(), firstName: "Arthur", lastName: "Stonecold", role: "VP of Software", company: "HSBC LTD", email: "xxx.x.com", phoneNumber: "-+44 ----", address: "---"), .init(id: .init(), firstName: "Daniel", lastName: "James", role: "Chief Operating Officer", company: "Fidelity Corporation", email: "daniel@fid.com", phoneNumber: "+4 ----", address: "fdada")]
    
    @State private var searchText = ""
    @State private var showEditor: BusinessCard? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    searchBar
                }
                
                ForEach(cards) { card in
                    Section {
                        Button(action: {
                            showEditor = card
                        }, label: {
                            BusinessCardView(card: card)
                        })
                    }
                }
            }
            .foregroundStyle(.primaryText)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $showEditor, content: { item in
                NavigationStack {
                    CardEditorView()
                }
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        
                    }, label: {
                        Label("Settings", systemImage: "slider.horizontal.3")
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    Text("CardLink")
                        .font(.appTitle3)
                        .foregroundColor(.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            
                        } label: {
                            Label("Nearby Exchange", systemImage: "shared.with.you")
                        }
                        
                        Button {
                            
                        } label: {
                            Label("Scan Paper Card", systemImage: "camera.viewfinder")
                        }
                        
                        Button {
                            
                        } label: {
                            Label("Manual Entry", systemImage: "plus")
                        }
                    } label: {
                        Label("Add Card", systemImage: "plus")
                    }
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
