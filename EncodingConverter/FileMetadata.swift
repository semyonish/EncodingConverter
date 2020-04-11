//
//  FileMetadata.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 01.04.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import AppKit

struct FileMetadata {
    let name: String
    let icon: NSImage
    let color: NSColor
    let isDirectory: Bool
    let url: URL
    var encoding: FileEncoding? // у папок нет кодировки
    
    var encodingDescription: String {
        return isDirectory ? "folder" : (encoding?.description ?? "not found")
    }
}
