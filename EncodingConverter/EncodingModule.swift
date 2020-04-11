//
//  EncodingModule.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 06.04.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import Foundation

enum FileEncoding: String {
    case utf8 = "UTF-8"
    case utf8withBOM = "UTF-8 with BOM"
    case identificationError = "FAILED"
    
    init(stringEncoding: String.Encoding, bom: Bool) {
        switch stringEncoding {
        case .utf8:
            self = bom ? .utf8withBOM : .utf8
        default:
            self = .identificationError
        }
    }
}

class FileEncoder {
    
    static let supportedEncodings: [FileEncoding] = [ .utf8, .utf8withBOM]
    
    // MARK: - Public methods
    
    static func getEncoding(of fileURL: URL) -> FileEncoding {
        do {
            var stringEncoding = String.Encoding.utf8
            _ = try String.init(contentsOf: fileURL, usedEncoding: &stringEncoding)

            return FileEncoding(stringEncoding: stringEncoding, bom: findBOM(in: fileURL))
        } catch {
            print("error checking encoding \(fileURL)")
            return FileEncoding.identificationError
        }
    }
    
    static func encode(file: URL, to newEncoding: FileEncoding) -> Bool {
        let oldEncoding = getEncoding(of: file)
        
        switch (oldEncoding, newEncoding) {
        case (.utf8, .utf8withBOM):
            return addBom(to: file)
        case (.utf8withBOM, .utf8):
            return removeBOM(from: file)
        default:
            print("FileEncoder.encode failed call with oldEnc = \(oldEncoding.rawValue), newEnc = \(newEncoding.rawValue)")
            return false
        }
    }
    
    //MARK: - BOM processing
    
    static private let BOM = "\u{FEFF}".data(using: .utf8)
    
    static private func findBOM(in file: URL) -> Bool {
        guard let data = try? Data(contentsOf: file) else {
            return false
        }
        
        return findBom(in: data)
    }
    
    static private func findBom(in data: Data) -> Bool {
        return data.count >= 3 && data.prefix(3) == BOM
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
    
    static private func removeBOM(from file: URL) -> Bool {
        do
        {
            let fileData = try Data(contentsOf: file)
            
            if !findBom(in: fileData) {
                return false;
            }
            
            let resultData = fileData.suffix(from: 3)
            
            try resultData.write(to: file)
            
            return true
        }
        catch
        {
            return false
        }
    }
}
