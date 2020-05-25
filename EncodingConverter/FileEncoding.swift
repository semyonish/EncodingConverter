//
//  FileEncoding.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 24.05.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import Foundation

enum FileEncoding: String {
    case ascii = "US-ASCII"
    case utf8 = "UTF-8"
    case utf8withBOM = "UTF-8 with BOM"
    case utf16LE = "UTF-16LE"
    case utf16BE = "UTF-16BE"
    case utf32LE = "UTF-32LE"
    case utf32BE = "UTF-32BE"
    case xMacCyrillic = "x-mac-cyrillic"
    case windows1251 = "windows-1251"
    case identificationError = "FAILED"
    
    init (utf8WithBom bom: Bool) {
        self = bom ? .utf8withBOM : .utf8
    }
}
