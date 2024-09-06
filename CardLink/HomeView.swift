//
//  HomeView.swift
//  CardLink
//
//  Created by Sahil Ak on 05/08/2024.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: BusinessCard.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BusinessCard.timestamp_, ascending: false)], animation: .default)
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
    
    @State private var showEditor: BusinessCard? = nil
    @State private var showViewer: BusinessCard? = nil
    
    @State private var showOCRScreen: Bool = false
    
    @State private var recognizedText: String = ""
    
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
                        context.delete(cards[offset])
                    }
                }
            }
            .foregroundStyle(.primaryText)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $showViewer) { cardToView in
                CardViewer(card: cardToView)
                    .presentationDetents([.fraction(0.44)])
            }
            .sheet(item: $showEditor, onDismiss: {
                try? context.save()
            }, content: { cardToView in
                CardEditorView(card: cardToView)
            })
            .sheet(isPresented: $showOCRScreen, onDismiss: {
                if !recognizedText.isEmpty {
                    if let contents = try? parseScannedText(recognizedText) {
                        let newCard = BusinessCard(context: context)
                        newCard.timestamp = .now
                        
                        newCard.update(with: contents)
                        
                        context.insert(newCard)
                        
                        showEditor = newCard
                    } else {
                        // TODO: Show an error - "Error parsing scanned card. Please try again."
                        
                    }
                }
                
                recognizedText = ""
            }, content: {
                DocumentCameraView(recognizedText: $recognizedText)
                    .ignoresSafeArea(edges: .all)
                    .interactiveDismissDisabled()
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showOCRScreen = true
                    }, label: {
                        Label("Scan Cards", systemImage: "camera.viewfinder")
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    Text("CardLink")
                        .font(.appTitle3)
                        .foregroundColor(.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let newCard = BusinessCard(context: context)
                        newCard.timestamp = Date()
                        
                        context.insert(newCard)
                        showEditor = newCard
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
    
    func parseScannedText(_ text: String) throws -> BusinessCardContent {
        var contents = BusinessCardContent()
        
        // Any line could contain the name on the business card.
        var potentialNames = text.components(separatedBy: .newlines)
        
        // Create an NSDataDetector to parse the text, searching for various fields of interest.
        let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
        let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
        
        for match in matches {
            let matchStartIdx = text.index(text.startIndex, offsetBy: match.range.location)
            let matchEndIdx = text.index(text.startIndex, offsetBy: match.range.location + match.range.length)
            let matchedString = String(text[matchStartIdx..<matchEndIdx])
            
            // This line has been matched so it doesn't contain the name on the business card.
            while !potentialNames.isEmpty && (matchedString.contains(potentialNames[0]) || potentialNames[0].contains(matchedString)) {
                potentialNames.remove(at: 0)
            }
        
            switch match.resultType {
            case .address:
                contents.address = matchedString
                
            case .phoneNumber:
                contents.numbers.append(matchedString)
                
            case .link:
                if let url = match.url, url.absoluteString.contains("mailto") {
                    contents.email = matchedString
                } else {
                    contents.website = matchedString
                }
                
            default:
                print("\(matchedString) type:\(match.resultType)")
            }
        }
        
        if !potentialNames.isEmpty {
            // Take the top-most unmatched line to be the person/business name.
            contents.name = potentialNames.first ?? ""
        }
        
        return contents
    }
}

struct BusinessCardContent {
    var name: String = ""
    
    var role: String = ""
    
    var organisation: String = ""
    
    var email: String = ""
    
    var numbers: [String] = []
    
    var website: String = ""
    
    var address: String = ""
}

#Preview {
    HomeView()
}

