//
//  FileEncoding.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 24.05.2020.
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
