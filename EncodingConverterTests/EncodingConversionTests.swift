//
//  EncodingConversionTests.swift
//  EncodingConverterTests
//
//  Created by Семён Ишханян on 26.05.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import XCTest
@testable import EncodingConverter

class EncodingConversionTests: TestBase {
    
    func doConversionTest(content: String, stringEncoding: String.Encoding, testEncoding: FileEncoding) throws {
        let fileURL = try createTempFile(with: content, encoding: stringEncoding)
        let status = FileEncoder.encode(file: fileURL, to: testEncoding)
        let finalEncoding = FileEncoder.getEncoding(of: fileURL)
        
        XCTAssertTrue(status)
        XCTAssertEqual(finalEncoding, testEncoding)
    }
    
    func doConversionTestWithFalseStatus(content: String, stringEncoding: String.Encoding, testEncoding: FileEncoding, expectableEncoding: FileEncoding) throws {
        let fileURL = try createTempFile(with: content, encoding: stringEncoding)
        let status = FileEncoder.encode(file: fileURL, to: testEncoding)
        let finalEncoding = FileEncoder.getEncoding(of: fileURL)
        
        XCTAssertFalse(status)
        XCTAssertEqual(finalEncoding, expectableEncoding)
    }
    
    func testUTF8ToAscii() throws {
        try doConversionTest(content: "test", stringEncoding: .utf8, testEncoding: .ascii)
        try doConversionTestWithFalseStatus(content: "test русский",
                                            stringEncoding: .utf8,
                                            testEncoding: .ascii,
                                            expectableEncoding: .utf8)
    }

    func testUTF8ToUTF8WithBom() throws {
        try doConversionTest(content: "test русский", stringEncoding: .utf8, testEncoding: .utf8withBOM)
    }
    
    func testUTF8ToWindows1251() throws {
        try doConversionTest(content: "test русский", stringEncoding: .utf8, testEncoding: .windows1251)
    }
    
    // Ascii can be converted only to UTF8 with BOM
    func testAsciiToUTF8WithBOM() throws {
        try doConversionTest(content: "test", stringEncoding: .ascii, testEncoding: .utf8withBOM)
    }
    
    func testUTF8WithBOMToUTF8() throws {
        try doConversionTest(content: BOMString + "test русский", stringEncoding: .utf8, testEncoding: .utf8)
    }
    
    func testUTF8WithBOMToWindows1251() throws {
        try doConversionTest(content: BOMString + "test русский", stringEncoding: .utf8, testEncoding: .windows1251)
    }
    
    func testUTF8WithBOMToAscii() throws {
        try doConversionTest(content: BOMString + "test", stringEncoding: .utf8, testEncoding: .ascii)
        try doConversionTestWithFalseStatus(content: BOMString + "test русский",
                                            stringEncoding: .utf8,
                                            testEncoding: .ascii,
                                            expectableEncoding: .utf8withBOM)
    }
    
    func testWindows1251ToUTF8() throws {
        try doConversionTest(content: "test русский", stringEncoding: .windowsCP1251, testEncoding: .utf8)
    }
    
    func testWindows1251ToUTF8WithBOM() throws {
        try doConversionTest(content: "test русский", stringEncoding: .windowsCP1251, testEncoding: .utf8withBOM)
    }
    
    func testWindows1251ToAscii() throws {
        try doConversionTest(content: "test", stringEncoding: .windowsCP1251, testEncoding: .ascii)
        try doConversionTestWithFalseStatus(content: "test русский",
                                            stringEncoding: .windowsCP1251,
                                            testEncoding: .ascii,
                                            expectableEncoding: .windows1251)
    }
    
    

}
