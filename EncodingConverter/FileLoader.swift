//
//  FileLoader.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 01.04.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import AppKit

class FileLoader {
    
    func loadFiles(from folder: URL) -> [FileMetadata] {
        var files = [FileMetadata]()
        
        let requiredAttributes = [URLResourceKey.localizedNameKey,
                                  URLResourceKey.effectiveIconKey,
                                  URLResourceKey.typeIdentifierKey,
                                  URLResourceKey.isDirectoryKey,
                                  URLResourceKey.isPackageKey]
        
        if let enumerator = FileManager.default.enumerator(at: folder,
                                                           includingPropertiesForKeys: requiredAttributes,
                                                           options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants],
                                                           errorHandler: nil)
        {
            while let fileUrl = enumerator.nextObject() as? URL {
                print("\(fileUrl)")

                guard let file = try? (fileUrl as NSURL).resourceValues(forKeys: requiredAttributes) else {
                    print("reading attributes error")
                    continue
                }
                
                let isDirectory = (file[URLResourceKey.isDirectoryKey] as? NSNumber)?.boolValue ?? false
                
                let encoding = !isDirectory ? getEncoding(of: fileUrl) : "folder"
                
                
                files.append(FileMetadata(name: file[URLResourceKey.localizedNameKey] as? String ?? "",
                                           icon: file[URLResourceKey.effectiveIconKey] as? NSImage  ?? NSImage(),
                                           color: NSColor(),
                                           isDirectory: isDirectory,
                                           url: fileUrl,
                                           encoding: encoding))
            }
        }
        
        return files
    }
    
    private func getEncoding(of fileURL: URL) -> String {
        var resultEncoding = String.Encoding.ascii
        
        do {
            _ = try String.init(contentsOf: fileURL, usedEncoding: &resultEncoding)
            
            if resultEncoding == .utf8 {
                let data = try Data(contentsOf: fileURL)
                let BOM = "\u{FEFF}".data(using: .utf8)
                if data.prefix(3) == BOM {
                    return String.Encoding.utf8.description + "(with BOM)"
                }
            }
            
        } catch {
            print("error checking encoding \(fileURL)")
            return "not found (maybe Windows)"
        }
        
        return resultEncoding.description
    }
}
