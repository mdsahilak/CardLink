//
//  ScannerViewModel.swift
//  CardLink
//
//  Created by Sahil Ak on 12/09/2024.
//

import SwiftUI

@MainActor
final class ScannerViewModel: ObservableObject {
    @Published var openCamera: Bool = false
    @Published var showEditor: BusinessCardContent? = nil
    
    @Published var recognizedText: String = ""
    
    /// Process the scanned text and extract information relevant for a business card
    /// - Parameter text: The text to be processed and parsed as content
    /// - Returns: The relevant business card content from the input text
    func parseScannedText(_ text: String) throws -> BusinessCardContent {
        var contents = BusinessCardContent()
        
        var textComponents = text.components(separatedBy: .newlines)
        
        // Create an NSDataDetector to parse the text.
        let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
        let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
        
        for match in matches {
            let matchStartIdx = text.index(text.startIndex, offsetBy: match.range.location)
            let matchEndIdx = text.index(text.startIndex, offsetBy: match.range.location + match.range.length)
            let matchedString = String(text[matchStartIdx..<matchEndIdx])
            
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
    
    /// Operations to be performed when the camera is dismissed
    func cameraDismissed() {
        if !recognizedText.isEmpty {
            do {
                let content = try parseScannedText(recognizedText)
                showEditor = content
            } catch {
                showEditor = BusinessCardContent()
                
                print("Could not parse text! Error: \(error)")
            }
        }
        
        self.recognizedText = ""
    }
    
}
