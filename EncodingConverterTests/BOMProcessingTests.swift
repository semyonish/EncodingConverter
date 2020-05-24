//
//  BOMProcessingTests.swift
//  EncodingConverterTests
//
//  Created by Семён Ишханян on 24.05.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import XCTest
@testable import EncodingConverter

class BOMProcessingTests: XCTestCase {
    
    let BOMString = "\u{FEFF}"
    
    func temporaryFileURL() -> URL {
        
        // Create a URL for an unique file in the system's temporary directory.
        let directory = NSTemporaryDirectory()
        let filename = UUID().uuidString
        let fileURL = URL(fileURLWithPath: directory).appendingPathComponent(filename)
        
        // Add a teardown block to delete any file at `fileURL`.
        addTeardownBlock {
            do {
                let fileManager = FileManager.default
                // Check that the file exists before trying to delete it.
                if fileManager.fileExists(atPath: fileURL.path) {
                    // Perform the deletion.
                    try fileManager.removeItem(at: fileURL)
                    // Verify that the file no longer exists after the deletion.
                    XCTAssertFalse(fileManager.fileExists(atPath: fileURL.path))
                }
            } catch {
                // Treat any errors during file deletion as a test failure.
                XCTFail("Error while deleting temporary file: \(error)")
            }
        }
        
        // Return the temporary file URL for use in a test method.
        return fileURL
        
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
