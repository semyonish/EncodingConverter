//
//  FileMetadata.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 24.05.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import AppKit

struct FileMetadata {
    let name: String
    let icon: NSImage
    let color: NSColor
    let isDirectory: Bool
    let url: URL
    let modificationDate: Date
    var encoding: FileEncoding
    
    var encodingDescription: String {
        return isDirectory ? "folder" : encoding.rawValue
    }
}

enum FileMetadataOrderKey: String {
    case name
    case modificationDate
}

public func itemCompare<T: Comparable>(lhs: T, rhs: T, ascending: Bool) -> Bool {
    return ascending ? (lhs < rhs) : (rhs < lhs)
}
