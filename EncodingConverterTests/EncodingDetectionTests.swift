//
//  EncodingDetectionTests.swift
//  EncodingConverterTests
//
//  Created by Семён Ишханян on 25.05.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import XCTest
@testable import EncodingConverter

class EncodingDetectionTests: XCTestCase {

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
    
    // asciiCharacters = " !#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~'"
    func testAsciiDetection() throws {
        let fileURL = temporaryFileURL()
        
        let content = "test"
        try content.write(to: fileURL, atomically: true, encoding: .ascii)
        
        let result = FileEncoder.getEncoding(of: fileURL)

        XCTAssertEqual(result, FileEncoding.ascii)
    }

    func testUTF8Detection() throws {
        let fileURL = temporaryFileURL()
        
        let content = "test русские буквы"
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        
        let result = FileEncoder.getEncoding(of: fileURL)

        XCTAssertEqual(result, FileEncoding.utf8)
    }
    
    func testUTF8WithBomDetection() throws {
        let fileURL = temporaryFileURL()
        
        let content = BOMString + "test"
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        
        let result = FileEncoder.getEncoding(of: fileURL)

        XCTAssertEqual(result, FileEncoding.utf8withBOM)
    }
    
    func testWindows1251Detection() throws {
        let fileURL = temporaryFileURL()
        
        let content = "test русские буквы"
        try content.write(to: fileURL, atomically: true, encoding: .windowsCP1251)
        
        let result = FileEncoder.getEncoding(of: fileURL)

        XCTAssertEqual(result, FileEncoding.windows1251)
    }
}
