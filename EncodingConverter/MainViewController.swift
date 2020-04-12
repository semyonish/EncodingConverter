//
//  MainViewController.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 01.04.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadFiles()
        
        filesTableView.dataSource = self
        filesTableView.delegate = self
        
        filesTableView.doubleAction = #selector(self.tableViewDoubleClick)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var filesTableView: NSTableView!
    
    // MARK: - Toolbar buttons handlers
    
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
    
    @objc func targetEncodingSelected(sender: NSMenuItem) {
        targetEncoding = FileEncoding.init(rawValue: sender.title)
    }
    
    @IBAction func encodeToUTF8BOM(_ sender: Any) {
        guard let targetEncoding = targetEncoding else {
            return
        }
        
        let indices = filesTableView.selectedRowIndexes
        for index in indices {
            convertStatuses[index] =
                FileEncoder.encode(file: files[index].url, to: targetEncoding)
                ? ConvertStatus.Converted
                : ConvertStatus.Error
        }
        
        refreshEncodings()
    }
    
    // MARK: - Internal data types
    
    fileprivate enum CellIdentifiers {
        static let NameCell = NSUserInterfaceItemIdentifier("NameCellId")
        static let EncodingCell = NSUserInterfaceItemIdentifier("EncodingCellId")
        static let ConvertStatus = NSUserInterfaceItemIdentifier("ConvertStatusCellId")
    }
    
    fileprivate enum ConvertStatus: String {
        case Converted = "OK"
        case Error = "Failed"
        case NotSelected = ""
    }
    
    // MARK: - Model objects
    
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
    
    private var targetEncoding: FileEncoding?
    
    private var convertStatuses = [ConvertStatus]()
    
    // MARK: - Private methods
    
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
    
    // not delegate method
    // handler for double click on file
    @objc func tableViewDoubleClick(_ sender: AnyObject) {
        let clickedFile = files[filesTableView.selectedRow]
        if clickedFile.isDirectory {
            openedFolderUrl = clickedFile.url
        }
    }
    
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
