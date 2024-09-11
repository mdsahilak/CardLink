//
//  TrashView.swift
//  CardLink
//
//  Created by Sahil Ak on 09/09/2024.
//

import SwiftUI
import CoreData

struct TrashView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: BusinessCard.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BusinessCard.timestamp_, ascending: false)], predicate: NSPredicate(format: "isTrashed_ == %@", NSNumber(value: true)), animation: .default)
    private var fetchedCards: FetchedResults<BusinessCard>
    
    @State private var showClearTrashAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(fetchedCards) { (card) in
                    ItemView(card)
                        .padding(.vertical)
                }
            }
            .listStyle(PlainListStyle())
            .font(.appBody)
            .foregroundColor(.primaryText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Trash")
                        .font(.appTitle3)
                        .foregroundColor(.accentColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EmptyTrashButton
                }
                
            }
            .alert(isPresented: $showClearTrashAlert, content: {
                Alert(title: Text("Empty Trash"), message: Text("Are you sure you want to empty your trash? This cannot be undone."), primaryButton: .destructive(Text("Empty All Trash Items")) { clearAllTrashItems() }, secondaryButton: .cancel())
            })
        }
    }
    
    private func ItemView(_ card: BusinessCard) -> some View {
        HStack {
            Button(action: {
                HapticController.send(force: .light)
                card.isTrashed = false
            }, label: {
                RecoverButtonView
            })
            .buttonStyle(ScaledButtonStyle())
            
            Spacer()
            
            VStack {
                Text(card.name.isEmpty ? "---" : card.name)
                    .font(.appHeadline)
                    .lineLimit(1)
                
                Text(card.organisation.isEmpty ? "---" : card.organisation)
                    .font(.appFootnote)
                    .lineLimit(2)
            }
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                HapticController.send(force: .light)
                context.delete(card)
            }, label: {
                DeleteButtonView
            })
            .buttonStyle(ScaledButtonStyle())
        }
    }
    
    private var RecoverButtonView: some View {
        Label("Recover", systemImage: "arrow.counterclockwise.circle")
            .labelStyle(IconOnlyLabelStyle())
            .font(.appTitle3)
            .foregroundColor(.accentColor)
            .padding()
            .frame(width: 44, height: 44, alignment: .center)
    }
    
    private var DeleteButtonView: some View {
        Label("Delete", systemImage: "trash.circle")
            .labelStyle(IconOnlyLabelStyle())
            .font(.appTitle3)
            .foregroundColor(.accentColor)
            .padding()
            .frame(width: 44, height: 44, alignment: .center)
    }
    
    private var EmptyTrashButton: some View {
        Button {
            showClearTrashAlert.toggle()
        } label: {
            Label("Empty Trash", systemImage: "trash.slash.circle")
        }
        .isInteractive(fetchedCards.count > 0)
    }
    
    private func clearAllTrashItems() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeWave")
        fetchRequest.predicate = NSPredicate(format: "isTrashed_ == %@", NSNumber(value: true))
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.executeAndMergeChanges(using: batchDeleteRequest)
            try context.save()
        } catch {
          print (error)
        }

    }
    
}

#Preview {
    TrashView()
}
