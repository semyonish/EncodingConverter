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
    
    static let supportedEncodings: [FileEncoding] = [ .utf8, .utf8withBOM]
    
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
        
        switch (oldEncoding, newEncoding) {
        case (.utf8, .utf8withBOM):
            return BOMProcessor.addBom(to: file)
        
        case (.utf8withBOM, .utf8):
            return BOMProcessor.removeBOM(from: file)
        
        default:
            print("FileEncoder.encode failed call with oldEnc = \(oldEncoding.rawValue), newEnc = \(newEncoding.rawValue)")
            return false
        }
    }

}

