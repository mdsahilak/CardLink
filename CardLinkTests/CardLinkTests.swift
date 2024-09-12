//
//  CardLinkTests.swift
//  CardLinkTests
//
//  Created by Sahil Ak on 12/09/2024.
//

import XCTest
@testable import CardLink

@MainActor
final class CardLinkTests: XCTestCase {
    private var scannerVM: ScannerViewModel!
    
    override func setUp() {
        super.setUp()
        scannerVM = ScannerViewModel()
    }

    override func tearDown() {
        super.tearDown()
        scannerVM = nil
    }
    
    // MARK: Unit Testing
    func testInitialCameraIsNotOpen() {
        XCTAssertFalse(scannerVM.openCamera, "Camera should not be open.")
    }
    
    func testInitialEditorIsNotVisible() {
        XCTAssertNil(scannerVM.showEditor, "Show Editor should be nil.")
    }
    
    func testInitialRecognisedTextIsEmpty() {
        XCTAssertEqual(scannerVM.recognizedText, "", "Recognised text should be empty.")
    }
    
    func testTextParsingAlgorithmLogic() throws {
        let scannedText: String = """
        EAST INDIA ARMS
        BOB BENTON
        General Manager
        67 Fenchurch Street, London, EC3M 4BR
        eastindiaarms@shepherd-neame.co.uk
        T: 0207 265 5121 M: 07956 593457
        www.eastindiaarms.co.uk
        """
        
        let parsedContent = try scannerVM.parseScannedText(scannedText)
        
        let expectedContent = BusinessCardContent(
            name: "Bob Benton",
            role: "General Manager",
            organisation: "East India Arms",
            email: "eastindiaarms@shepherd-neame.co.uk",
            telePhone: "0207 265 5121",
            mobilePhone: "07956 593457",
            website: "www.eastindiaarms.co.uk",
            address: "67 Fenchurch Street, London, EC3M 4BR"
        )
        
        XCTAssertEqual(parsedContent, expectedContent, "Parsed content is incorrect.")
    }
    
    // MARK: Performance Testing
    func testTextParsingAlgorithmPerformance() {
        measure {
            try? testTextParsingAlgorithmLogic()
        }
    }
}
