//
//  FileEncoder.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 06.04.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import Foundation

class FileEncoder {
    static func getEncoding(of fileURL: URL) -> FileEncoding {
         do {
            var stringEncoding = String.Encoding.utf8
            _ = try String.init(contentsOf: fileURL, usedEncoding: &stringEncoding)
            
            return FileEncoding(encoding: stringEncoding,
                                bom: stringEncoding == .utf8 && findBOM(in: fileURL))
        } catch {
            print("error checking encoding \(fileURL)")
            return FileEncoding(encoding: nil, bom: false)
        }
    }
    
    static private let BOM = "\u{FEFF}".data(using: .utf8)
    
    static private func findBOM(in file: URL) -> Bool {
        guard let data = try? Data(contentsOf: file) else {
            return false
        }
        
        return data.prefix(3) == BOM
    }
}

struct FileEncoding {
    let encoding: String.Encoding?
    let bom: Bool
    
    var description: String {
        guard let encoding = encoding else { return "not found" }
        var result = encoding.description
        if (encoding == .utf8 && bom) {
            result += " (with BOM)"
        }
        return result
    }
}
