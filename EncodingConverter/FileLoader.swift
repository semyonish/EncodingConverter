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
                                  URLResourceKey.isPackageKey,
                                  URLResourceKey.contentModificationDateKey]
        
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
                
                let name = file[URLResourceKey.localizedNameKey] as? String ?? ""
                let icon = file[URLResourceKey.effectiveIconKey] as? NSImage  ?? NSImage()
                let isDirectory = (file[URLResourceKey.isDirectoryKey] as? NSNumber)?.boolValue ?? false
                let modificationDate = file[URLResourceKey.contentModificationDateKey] as? Date ?? Date.distantPast
                let encoding = FileEncoder.getEncoding(of: fileUrl)
                
                files.append(FileMetadata(name: name,
                                           icon: icon,
                                           color: NSColor(),
                                           isDirectory: isDirectory,
                                           url: fileUrl,
                                           modificationDate: modificationDate,
                                           encoding: encoding))
            }
        }
        
        return files
    }
}
