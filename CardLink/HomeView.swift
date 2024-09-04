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
    
//    @State private var cards: [BusinessCardDraft] = [.mock]
    
    @State private var searchText = ""
    @State private var showEditor: BusinessCard? = nil
    
    @State private var showNearbyExchange: Bool = false
    @State private var showOCRScreen: Bool = false
    
    @State private var recognizedText: String = ""
    
    @State private var contents = BusinessCardContents()
    
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
                .onDelete { offsets in
                    for offset in offsets {
                        context.delete(cards[offset])
                    }
                }
            }
            .foregroundStyle(.primaryText)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $showEditor, onDismiss: {
                try? context.save()
            }, content: { cardToView in
                CardEditorView(card: cardToView)
            })
            .sheet(isPresented: $showOCRScreen, onDismiss: {
                print("Text: \(recognizedText)")
                print("----")
                parseTextContents(text: recognizedText)
                print("Contents ", contents)
            }, content: {
                DocumentCameraView(recognizedText: $recognizedText)
            })
//            .fullScreenCover(isPresented: $showNearbyExchange, content: {
//                NavigationStack {
//                    NearbyExchangeView()
//                }
//            })
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
                            showNearbyExchange = true
                        } label: {
                            Label("Nearby Exchange", systemImage: "shared.with.you")
                        }
                        
                        Button {
                            showOCRScreen = true
                        } label: {
                            Label("Scan Paper Card", systemImage: "camera.viewfinder")
                        }
                        
                        Button {
                            let newCard = BusinessCard(context: context)
                            newCard.timestamp = Date()
                            
                            context.insert(newCard)
                            showEditor = newCard
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
    
    func parseTextContents(text: String) {
        do {
            // Any line could contain the name on the business card.
            var potentialNames = text.components(separatedBy: .newlines)
            
            // Create an NSDataDetector to parse the text, searching for various fields of interest.
            let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
            let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
            
            for match in matches {
                let matchStartIdx = text.index(text.startIndex, offsetBy: match.range.location)
                let matchEndIdx = text.index(text.startIndex, offsetBy: match.range.location + match.range.length)
                let matchedString = String(text[matchStartIdx..<matchEndIdx])
                print(potentialNames)
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
                    if (match.url?.absoluteString.contains("mailto"))! {
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
                contents.name = potentialNames.first
            }
        } catch {
            print(error)
        }
    }
}

struct BusinessCardContents {
    typealias CardContentField = (name: String, value: String)
    
    var name: String?
    var numbers = [String]()
    var website: String?
    var address: String?
    var email: String?
    
    func availableContents() -> [CardContentField] {
        var contents = [CardContentField]()
 
        if let name = self.name {
            contents.append(("Name", name))
        }
        numbers.forEach { (number) in
            contents.append(("Number", number))
        }
        if let website = self.website {
            contents.append(("Website", website))
        }
        if let address = self.address {
            contents.append(("Address", address))
        }
        if let email = self.email {
            contents.append(("Email", email))
        }
        
        return contents
    }
}

#Preview {
    HomeView()
}
