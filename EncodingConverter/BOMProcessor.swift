//
//  BOMProcessor.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 24.05.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import Foundation

class BOMProcessor {
    static private let BOM = "\u{FEFF}".data(using: .utf8)
    
    static public func addBom(to file: URL) -> Bool
    {
        do
        {
            let fileData = try Data(contentsOf: file)
            
            if findBom(in: fileData) {
                return false
            }
            
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
    
    static public func removeBOM(from file: URL) -> Bool {
        do
        {
            let fileData = try Data(contentsOf: file)
            
            if !findBom(in: fileData) {
                return false;
            }
            
            let indexAfterBOM = fileData.startIndex + 3
            let resultData = fileData.suffix(from: indexAfterBOM)
            
            try resultData.write(to: file)
            
            return true
        }
        catch
        {
            return false
        }
    }
    
    static public func findBOM(in file: URL) -> Bool {
        guard let data = try? Data(contentsOf: file) else {
            return false
        }
        
        return findBom(in: data)
    }
    
    static private func findBom(in data: Data) -> Bool {
        return data.count >= 3 && data.prefix(3) == BOM
    }
}
