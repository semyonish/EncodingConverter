//
//  BOMProcessingTests.swift
//  EncodingConverterTests
//
//  Created by Семён Ишханян on 24.05.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import XCTest
@testable import EncodingConverter

class BOMProcessingTests: TestBase {

    func testAddingBomToFileContainedBOM() throws {
        let fileURL = temporaryFileURL()
        
        let content = BOMString + "testString"
        let contentData = content.data(using: .utf8)
        try contentData!.write(to: fileURL)
        
        let result = BOMProcessor.addBom(to: fileURL)
        
        let readData = try Data.init(contentsOf: fileURL)
        
        XCTAssertFalse(result)
        XCTAssertEqual(readData, contentData)
    }
    
    func testRemovingBomFromFileNotContainedBOM() throws {
        let fileURL = temporaryFileURL()
        
        let content = "testString"
        let contentData = content.data(using: .utf8)
        try contentData!.write(to: fileURL)
        
        let result = BOMProcessor.removeBOM(from: fileURL)
        
        let readData = try Data.init(contentsOf: fileURL)
        
        XCTAssertFalse(result)
        XCTAssertEqual(readData, contentData)
    }
    
    func testAddingBOM() throws {
        let fileURL = temporaryFileURL()
        
        let content = "testString"
        let bomContent = BOMString + content
        
        let contentData = content.data(using: .utf8)
        try contentData!.write(to: fileURL)
        let bomContentData = bomContent.data(using: .utf8)
        
        let result = BOMProcessor.addBom(to: fileURL)
        
        let readData = try Data.init(contentsOf: fileURL)
        
        XCTAssertTrue(result)
        XCTAssertEqual(readData, bomContentData)
    }
    
    func testRemovingBOM() throws {
        let fileURL = temporaryFileURL()
        
        let content = "testString"
        let bomContent = BOMString + content
        
        let contentData = content.data(using: .utf8)
        let bomContentData = bomContent.data(using: .utf8)
        try bomContentData!.write(to: fileURL)
        
        let result = BOMProcessor.removeBOM(from: fileURL)
        
        let readData = try Data.init(contentsOf: fileURL)
        
        XCTAssertTrue(result)
        XCTAssertEqual(readData, contentData)
    }

}
