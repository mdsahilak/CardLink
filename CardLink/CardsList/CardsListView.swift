//
//  CardsListView.swift
//  CardLink
//
//  Created by Sahil Ak on 05/08/2024.
//

import SwiftUI

struct CardsListView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: BusinessCard.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BusinessCard.timestamp_, ascending: false)], predicate: NSPredicate(format: "isTrashed_ == %@", NSNumber(value: false)), animation: .default)
    private var fetchedCards: FetchedResults<BusinessCard>
    
    private var cards: [BusinessCard] {
        fetchedCards.filter({ (card) -> Bool in
            if searchText.isEmpty {
                return true
            } else {
                return card.name.lowercased().contains(searchText.lowercased())
            }
        })
    }
    
    @State private var searchText = ""
    
    @State private var showEditorForNewCardContent: BusinessCardContent? = nil
    @State private var showViewer: BusinessCard? = nil
    
    @State private var showTrash: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    searchBar
                }
                
                ForEach(cards) { card in
                    Section {
                        Button(action: {
                            showViewer = card
                        }, label: {
                            BusinessCardView(card: card)
                        })
                    }
                }
                .onDelete { offsets in
                    for offset in offsets {
                        cards[offset].isTrashed = true
                    }
                }
            }
            .foregroundStyle(.primaryText)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $showViewer) { cardToView in
                CardDrawerViewer(card: cardToView)
                    .presentationDetents([.fraction(0.5)])
            }
            .sheet(item: $showEditorForNewCardContent) { content in
                CardEditorView(type: .create, content: content) { editedCardContent in
                    let newCard = BusinessCard(context: context)
                    newCard.timestamp = Date()
                    
                    newCard.update(with: editedCardContent)
                    
                    try? context.save()
                }
            }
            .sheet(isPresented: $showTrash, content: {
                TrashView()
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showTrash = true
                    }, label: {
                        Label("Recently Deleted", systemImage: "trash.circle")
                    })
                    
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Cards")
                        .font(.appTitle3)
                        .foregroundColor(.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let newContent = BusinessCardContent()
                        
                        showEditorForNewCardContent = newContent
                    } label: {
                        Label("Add Manual Card", systemImage: "plus")
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

