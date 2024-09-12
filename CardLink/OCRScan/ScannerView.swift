//
//  ScannerView.swift
//  CardLink
//
//  Created by Sahil Ak on 09/09/2024.
//

import SwiftUI

struct ScannerView: View {
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var vm: ScannerViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    vm.openCamera = true
                } label: {
                    VStack(spacing: 11) {
                        Image(systemName: "camera.viewfinder")
                            .font(.appTitle3)
                        
                        Text("Start AI Scan")
                    }
                    .padding()
                    .background(content: {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color(.buttonBackground))
                    })
                    .overlay {
                        RoundedRectangle(cornerRadius: 13)
                            .stroke()
                            .foregroundStyle(Color(.shadow))
                    }
                    .padding()
                }

            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("AI Scan")
                        .font(.appTitle3)
                        .foregroundColor(.primaryText)
                }
            }
        }
        .sheet(isPresented: $vm.openCamera, onDismiss: {
            vm.cameraDismissed()
        }, content: {
            OCRController(recognizedText: $vm.recognizedText)
                .ignoresSafeArea(edges: .all)
                .interactiveDismissDisabled()
        })
        .sheet(item: $vm.showEditor) { content in
            CardEditorView(type: .create, content: content) { editedCardContent in
                let newCard = BusinessCard(context: context)
                newCard.timestamp = Date()
                
                newCard.update(with: editedCardContent)
                
                try? context.save()
            }
        }
    }
    
}
