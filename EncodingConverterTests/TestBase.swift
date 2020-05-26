//
//  TestBase.swift
//  EncodingConverterTests
//
//  Created by Семён Ишханян on 26.05.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import XCTest
@testable import EncodingConverter

class TestBase: XCTestCase {
    
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
    
    func createTempFile(with content: String, encoding: String.Encoding) throws -> URL {
        let fileURL = temporaryFileURL()
        try content.write(to: fileURL, atomically: true, encoding: encoding)
        return fileURL
    }
    
}
