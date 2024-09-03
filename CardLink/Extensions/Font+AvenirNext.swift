//
//  Font+AvenirNext.swift
//  CardLink
//
//  Created by Sahil Ak on 08/08/2024.
//

import SwiftUI

private extension Font {
    enum AvenirNext {
        static let demiBold: String = "AvenirNext-DemiBold"
        
        static let medium: String = "AvenirNext-Medium"
        
        static let regular: String = "AvenirNext-Regular"
    }
}

extension Font {
    static let appLargeTitle = Font.custom(AvenirNext.medium, size: 33, relativeTo: .largeTitle)
    
    static let appTitle1 = Font.custom(AvenirNext.medium, size: 27, relativeTo: .title)
    
    static let appTitle2 = Font.custom(AvenirNext.medium, size: 21, relativeTo: .title2)
    
    static let appTitle3 = Font.custom(AvenirNext.medium, size: 19, relativeTo: .title3)
    
    static let appHeadline = Font.custom(AvenirNext.demiBold, size: 17, relativeTo: .headline)
    
    static let appSubheadline = Font.custom(AvenirNext.medium, size: 15, relativeTo: .subheadline)
     
    static let appBody = Font.custom(AvenirNext.regular, size: 17, relativeTo: .body)
    
    static let appCallout = Font.custom(AvenirNext.regular, size: 15, relativeTo: .callout)
    
    static let appCaption1 = Font.custom(AvenirNext.medium, size: 13, relativeTo: .caption)
    
    static let appCaption2 = Font.custom(AvenirNext.medium, size: 11, relativeTo: .caption2)
    
    static let appFootnote = Font.custom(AvenirNext.regular, size: 13, relativeTo: .footnote)
}

