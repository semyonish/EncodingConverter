//
//  EncodingDetectionTests.swift
//  EncodingConverterTests
//
//  Created by Семён Ишханян on 25.05.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import XCTest
@testable import EncodingConverter

class EncodingDetectionTests: TestBase {
    
    func doDetectingTest(content: String, stringEncoding: String.Encoding, testEncoding: FileEncoding) throws {
        let fileURL = try createTempFile(with: content, encoding: stringEncoding)
        let encdingDetected = FileEncoder.getEncoding(of: fileURL)

        XCTAssertEqual(encdingDetected, testEncoding)
    }
    
    // asciiCharacters = " !#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~'"
    func testAsciiDetection() throws {
        try doDetectingTest(content: "test", stringEncoding: .ascii, testEncoding: .ascii)
    }

    func testUTF8Detection() throws {
        try doDetectingTest(content: "test русский язык", stringEncoding: .utf8, testEncoding: .utf8)
    }
    
    func testUTF8WithBomDetection() throws {
        try doDetectingTest(content: BOMString + "test", stringEncoding: .utf8, testEncoding: .utf8withBOM)
    }
    
    func testWindows1251Detection() throws {
        try doDetectingTest(content: "test русский язык", stringEncoding: .windowsCP1251, testEncoding: .windows1251)
    }
}
