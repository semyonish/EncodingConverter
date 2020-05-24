//
//  EncodingModule.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 06.04.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import Foundation

class FileEncoder {
    
    static let supportedEncodings: [FileEncoding] = [ .utf8, .utf8withBOM]
    
    // MARK: - Public methods
    
    static func getEncoding(of fileURL: URL) -> FileEncoding {
        do {
            var stringEncoding = String.Encoding.utf8
            _ = try String.init(contentsOf: fileURL, usedEncoding: &stringEncoding)

            return FileEncoding(stringEncoding: stringEncoding, bom: BOMProcessor.findBOM(in: fileURL))
        } catch {
            print("FileEncoder.getENcoding error checking encoding \(fileURL)")
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
