//
//  FileLoader.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 01.04.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import AppKit

class FileLoader {
    
    static func loadFiles(from folder: URL) -> [FileMetadata] {
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
                let encoding = !isDirectory ? FileEncoder.getEncoding(of: fileUrl) : nil
                
                
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
    
    static func refreshEncdoings(files:[FileMetadata]) -> [FileMetadata] {
        return files.map { file in
            var newFile = file
            newFile.encoding = FileEncoder.getEncoding(of: file.url)
            return newFile
        }
    }
}
