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
    
    static func encode(file: URL, to newEncoding: FileEncoding) -> Bool {
        let oldEncoding = getEncoding(of: file)
        if oldEncoding.encoding == .utf8
            && oldEncoding.bom == false
            && newEncoding.encoding == .utf8
            && newEncoding.bom == true
        {
            return addBom(to: file)
        }
        else {
            return false
        }
    }
    
    static private let BOM = "\u{FEFF}".data(using: .utf8)
    
    static private func findBOM(in file: URL) -> Bool {
        guard let data = try? Data(contentsOf: file) else {
            return false
        }
        
        return data.prefix(3) == BOM
    }
    
    static private func addBom(to file: URL) -> Bool
    {
        do
        {
            let fileData = try Data(contentsOf: file)
            var resultData = BOM
            resultData?.append(fileData)
            try resultData?.write(to: file)
            return true
        }
        catch
        {
            return false
        }
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
    
    init(encoding: String.Encoding?, bom: Bool) {
        self.encoding = encoding
        self.bom = (encoding == .utf8) ? bom : false;
    }
}
