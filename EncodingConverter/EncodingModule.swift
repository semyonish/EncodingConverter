//
//  EncodingModule.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 06.04.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import Foundation
import UniversalDetector

class FileEncoder {
    
    static let supportedEncodings: [FileEncoding] = [ .utf8, .utf8withBOM, .ascii, .windows1251]
    
    // MARK: - Public methods
    
    static func getEncoding(of fileURL: URL) -> FileEncoding {
        do {
            let fileData = try Data.init(contentsOf: fileURL)
            let encName = UniversalDetector.encodingAsString(with: fileData) ?? "FAILED"
            
            var fileEncoding = FileEncoding.init(rawValue: encName) ?? FileEncoding.identificationError
            
            if fileEncoding == .utf8 {
                fileEncoding = FileEncoding(utf8WithBom: BOMProcessor.findBOM(in: fileURL))
            }
            
            return fileEncoding
        }
        catch {
            print("FileEncoder.getEncoding error checking encoding \(fileURL)")
            return FileEncoding.identificationError
        }
    }
    
    static func encode(file: URL, to newEncoding: FileEncoding) -> Bool {
        let oldEncoding = getEncoding(of: file)
        
        if oldEncoding == newEncoding {
            return true
        }
        
        switch (oldEncoding, newEncoding) {
        case (.ascii, .utf8):
            return true
        case (.ascii, .utf8withBOM):
            return BOMProcessor.addBom(to: file)
        
        case (.utf8, .ascii):
            return false
        case (.utf8, .utf8withBOM):
            return BOMProcessor.addBom(to: file)
        
        case (.utf8withBOM, .utf8):
            return BOMProcessor.removeBOM(from: file)
            
        case (.utf8withBOM, _):
            return encode(file: file, to: .utf8) && encode(file: file, to: newEncoding)
        
        case (_, .utf8withBOM):
            return encode(file: file, to: .utf8) && encode(file: file, to: .utf8withBOM)
        
        default:
            return encode(file: file, from: oldEncoding, to: newEncoding)
        }
    }
    
    static private func encode(file: URL, from oldEncoding: FileEncoding, to newEncoding: FileEncoding) -> Bool {
        do {
            let readData = try Data.init(contentsOf: file)
            if let stringData = String(data: readData, encoding: oldEncoding.stringEncoding) {
                try stringData.write(to: file, atomically: true, encoding: newEncoding.stringEncoding)
            } else {
                return false
            }
        }
        catch {
            return false
        }
        
        return true
    }
}

