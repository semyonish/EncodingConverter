//
//  TargetEncodingPopUpButton.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 12.04.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import Cocoa

class TargetEncodingPopUpButton: NSPopUpButton {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // cration of list of possible encodings in menu
        let menu = NSMenu(title: "TargetEncoding")
        
        let menuItemTitles = ["---"] + FileEncoder.supportedEncodings.map { $0.rawValue }
        
        for title in menuItemTitles {
            let item = NSMenuItem(title: title, action: #selector(MainViewController.targetEncodingSelected), keyEquivalent: "")
            menu.addItem(item)
        }
        
        self.menu = menu
    }
    
}
