//
//  ScannerView.swift
//  CardLink
//
//  Created by Sahil Ak on 09/09/2024.
//

import SwiftUI

struct ScannerView: View {
    @Environment(\.managedObjectContext) var context
    
    @State private var openCamera: Bool = false
    @State private var showEditor: BusinessCardContent? = nil
    
    @State private var recognizedText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    openCamera = true
                } label: {
                    VStack(spacing: 11) {
                        Image(systemName: "camera.viewfinder")
                            .font(.appTitle3)
                        
                        Text("Start Camera Scan")
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
        .sheet(isPresented: $openCamera, onDismiss: {
            if !recognizedText.isEmpty {
                if let content = try? parseScannedText(recognizedText) {
                    showEditor = content
                } else {
                    // TODO: Show an error - "Error parsing scanned card. Please try again."
                    print("Could not parse text!")
                }
            }
            
            recognizedText = ""
        }, content: {
            DocumentCameraView(recognizedText: $recognizedText)
                .ignoresSafeArea(edges: .all)
                .interactiveDismissDisabled()
        })
        .sheet(item: $showEditor) { content in
            CardEditorView(type: .create, content: content) { editedCardContent in
                let newCard = BusinessCard(context: context)
                newCard.timestamp = Date()
                
                newCard.update(with: editedCardContent)
                
                try? context.save()
            }
        }
    }
    
    
    
    func parseScannedText(_ text: String) throws -> BusinessCardContent {
        var contents = BusinessCardContent()
        
        print(text)
        
        // Any line could contain the name on the business card.
        var textComponents = text.components(separatedBy: .newlines)
        
        // Create an NSDataDetector to parse the text, searching for various fields of interest.
        let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
        let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
        
        for match in matches {
            let matchStartIdx = text.index(text.startIndex, offsetBy: match.range.location)
            let matchEndIdx = text.index(text.startIndex, offsetBy: match.range.location + match.range.length)
            let matchedString = String(text[matchStartIdx..<matchEndIdx])
            
            // This line has been matched so it doesn't contain the name on the business card.
            while !textComponents.isEmpty && (matchedString.contains(textComponents[0]) || textComponents[0].contains(matchedString)) {
                textComponents.remove(at: 0)
            }
            
            switch match.resultType {
            case .address:
                contents.address = matchedString
                
            case .phoneNumber:
                if contents.telePhone.isEmpty {
                    contents.telePhone = matchedString
                } else {
                    contents.mobilePhone = matchedString
                }
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
        
        // Process the remaining unmatched lines
        
        // The top line is the organisation's name
        // The next line is the person's name
        // The last line is the role
        switch textComponents.count {
        case 3..<Int.max:
            contents.organisation = textComponents[0].capitalized
            contents.name = textComponents[1].capitalized
            contents.role = textComponents[2].capitalized
            
        case 2:
            contents.name = textComponents[0].capitalized
            contents.role = textComponents[1].capitalized
            
        case 1:
            contents.name = textComponents[0].capitalized
            
        default:
            print("Could not find Name, Role or Organisation!")
        }
        
        return contents
    }
}

#Preview {
    ScannerView()
}
