//
//  MainViewController.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 01.04.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    fileprivate enum CellIdentifiers {
        static let NameCell = NSUserInterfaceItemIdentifier("NameCellId")
        static let EncodingCell = NSUserInterfaceItemIdentifier("EncodingCellId")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        files = FileLoader().loadFiles(from: URL(fileURLWithPath: "/"))
        
        filesTableView.dataSource = self
        filesTableView.delegate = self
    }
    
    @IBOutlet weak var filesTableView: NSTableView!
    
    private var files = [FileMetadata]()
    
}

extension MainViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return files.count
    }
}

extension MainViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn == filesTableView.tableColumns[0] {
            let cellView = filesTableView.makeView(withIdentifier:CellIdentifiers.NameCell, owner: nil) as? NSTableCellView
            cellView?.textField?.stringValue = files[row].name
            cellView?.imageView?.image = files[row].icon
            return cellView
        }
        else if tableColumn == filesTableView.tableColumns[1]
        {
            let cellView = filesTableView.makeView(withIdentifier:CellIdentifiers.EncodingCell, owner: nil) as? NSTableCellView
            cellView?.textField?.stringValue = files[row].isDirectory.description
            return cellView
        }
        
        return nil
    }
}
