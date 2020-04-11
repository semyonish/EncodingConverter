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
        static let ConvertStatus = NSUserInterfaceItemIdentifier("ConvertStatusCellId")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadFiles()
        
        filesTableView.dataSource = self
        filesTableView.delegate = self
    }
    
    @IBOutlet weak var filesTableView: NSTableView!
    
    private var openedFolderUrl = URL(fileURLWithPath: "/") {
        didSet {
            reloadFiles()
        }
    }
    
    private var files = [FileMetadata]() {
        didSet {
            filesTableView.reloadData()
        }
    }
    
    enum ConvertStatus: String {
        case Converted = "OK"
        case Error = "Failed"
        case NotSelected = ""
    }
    
    // если конвертация прошла успешно, то true
    private var convertStatuses = [ConvertStatus]()
    
    
    @IBAction func openFolder(_ sender: Any) {
        let folderDlg = NSOpenPanel()
        folderDlg.canChooseDirectories = true
        folderDlg.canChooseFiles = false;
        
        folderDlg.beginSheetModal(for: self.view.window!)
        { (response) in
            if response != NSApplication.ModalResponse.OK { return }
            self.openedFolderUrl = folderDlg.url!
        }
    }
    
    @IBAction func refreshFolder(_ sender: Any) {
        reloadFiles()
    }
    
    @IBAction func encodeToUTF8BOM(_ sender: Any) {
        let indices = filesTableView.selectedRowIndexes
        for index in indices {
            convertStatuses[index] =
                FileEncoder.encode(file: files[index].url, to: FileEncoding(encoding: .utf8, bom: true))
                ? ConvertStatus.Converted
                : ConvertStatus.Error
        }
        
        refreshEncodings()
    }
    
    private func reloadFiles() {
        files = FileLoader.loadFiles(from: openedFolderUrl)
        convertStatuses = Array.init(repeating: ConvertStatus.NotSelected, count: files.count)
    }
    
    private func refreshEncodings() {
        files = FileLoader.refreshEncdoings(files: files)
    }
}

extension MainViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return files.count
    }
}

extension MainViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn == filesTableView.tableColumns[0] { // name
            let cellView = filesTableView.makeView(withIdentifier:CellIdentifiers.NameCell, owner: nil) as? NSTableCellView
            cellView?.textField?.stringValue = files[row].name
            cellView?.imageView?.image = files[row].icon
            return cellView
        }
        else if tableColumn == filesTableView.tableColumns[1] { // encoding
            let cellView = filesTableView.makeView(withIdentifier:CellIdentifiers.EncodingCell, owner: nil) as? NSTableCellView
            cellView?.textField?.stringValue = files[row].encodingDescription
            return cellView
        }
        else if tableColumn == filesTableView.tableColumns[2] { // convert status
            let cellView = filesTableView.makeView(withIdentifier:CellIdentifiers.ConvertStatus, owner: nil) as? NSTableCellView
            cellView?.textField?.stringValue = convertStatuses[row].rawValue
            return cellView
        }
        
        return nil
    }
}
