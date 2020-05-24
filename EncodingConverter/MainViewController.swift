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
        
        filesModel.delegate = self
        configureTableView()
        reloadFiles()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var filesTableView: NSTableView!
    
    // MARK: - Toolbar buttons handlers
    
    @IBAction func openFolderBtnDidPressed(_ sender: Any) {
        let folderDlg = NSOpenPanel()
        folderDlg.canChooseDirectories = true
        folderDlg.canChooseFiles = false;
        
        folderDlg.beginSheetModal(for: self.view.window!)
        { (response) in
            if response != NSApplication.ModalResponse.OK { return }
            self.filesModel.setFolderUrl(folderDlg.url!)
        }
    }
    
    @IBAction func refreshFolderBtnDidPressed(_ sender: Any) {
        reloadFiles()
    }
    
    @IBAction func encodeBtnDidPressed(_ sender: Any) {
        guard let targetEncodingName = targetEncodingName else {
            return
        }
        
        let indexes = filesTableView.selectedRowIndexes
        let convertResults = filesModel.encodeFiles(from: indexes, toEncodingWithName: targetEncodingName)
        
        filesModel.refreshEncodings()
        
        for index in indexes {
            guard let result = convertResults[index] else
            {
                print("Error: there is not converting result for index = \(index)")
                continue
            }
            
            convertStatuses[index] = result ? ConvertStatus.Converted : ConvertStatus.Error
        }
    }
    
    @objc func targetEncodingSelected(sender: NSMenuItem) {
        targetEncodingName = sender.title
    }
    
    // MARK: - Internal data types
    
    fileprivate enum CellIdentifiers {
        static let NameCell = NSUserInterfaceItemIdentifier("NameCellId")
        static let EncodingCell = NSUserInterfaceItemIdentifier("EncodingCellId")
        static let ModificationDateCell = NSUserInterfaceItemIdentifier("ModificationDateCellId")
        static let ConvertStatusCell = NSUserInterfaceItemIdentifier("ConvertStatusCellId")
    }
    
    fileprivate enum CellIndex {
        static let NameCell = 0
        static let EncodingCell = 1
        static let ModificationDateCell = 2
        static let ConvertStatusCell = 3
    }
    
    fileprivate enum ConvertStatus: String {
        case Converted = "OK"
        case Error = "Failed"
        case NotSelected = ""
    }
    
    // MARK: - private fields
    
    private var filesModel = FilesModel()
    
    private var targetEncodingName: String?
    
    private var presentingFiles = [FileMetadata]()
    private var convertStatuses = [ConvertStatus]()
    {
        didSet {
            filesTableView.reloadData()
        }
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        filesTableView.dataSource = self
        filesTableView.delegate = self
        
        filesTableView.doubleAction = #selector(self.tableViewDoubleClick)
        
        filesTableView.tableColumns[CellIndex.NameCell].sortDescriptorPrototype =
            NSSortDescriptor(key: FileMetadataOrderKey.name.rawValue, ascending: true)
        
        filesTableView.tableColumns[CellIndex.ModificationDateCell].sortDescriptorPrototype =
            NSSortDescriptor(key: FileMetadataOrderKey.modificationDate.rawValue, ascending: false)
    }
    
    private func reloadFiles() {
        filesModel.reloadFiles()
        resetConvertStatuses()
    }
    
    private func resetConvertStatuses() {
        convertStatuses = Array.init(repeating: ConvertStatus.NotSelected, count: filesModel.getFilesCount())
    }
    
}

extension MainViewController: FilesModelDelegate {
    func updateUI() {
        presentingFiles = filesModel.getFiles()
        filesTableView.reloadData()
        
        resetConvertStatuses()
    }
}

extension MainViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filesModel.getFilesCount()
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor = filesTableView.sortDescriptors.first else {
            return
        }
        
        if let sortKey = FileMetadataOrderKey(rawValue: sortDescriptor.key ?? "") {
            filesModel.setSortParameters(key: sortKey, ascending: sortDescriptor.ascending)
        }
    }
    
}

extension MainViewController: NSTableViewDelegate {
    
    // not delegate method
    // handler for double click on file
    @objc func tableViewDoubleClick(_ sender: AnyObject) {
        if filesTableView.selectedRow < 0 {
            return
        }
        
        filesModel.openFolderWith(row: filesTableView.selectedRow)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn == filesTableView.tableColumns[CellIndex.NameCell] {
            let cellView = filesTableView.makeView(withIdentifier:CellIdentifiers.NameCell, owner: nil) as? NSTableCellView
            cellView?.textField?.stringValue = presentingFiles[row].name
            cellView?.imageView?.image = presentingFiles[row].icon
            return cellView
        }
        else if tableColumn == filesTableView.tableColumns[CellIndex.EncodingCell] {
            let cellView = filesTableView.makeView(withIdentifier:CellIdentifiers.EncodingCell, owner: nil) as? NSTableCellView
            cellView?.textField?.stringValue = presentingFiles[row].encodingDescription
            return cellView
        }
        else if tableColumn == filesTableView.tableColumns[CellIndex.ModificationDateCell] {
            let cellView = filesTableView.makeView(withIdentifier:CellIdentifiers.ConvertStatusCell, owner: nil) as? NSTableCellView
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            cellView?.textField?.stringValue = dateFormatter.string(from: presentingFiles[row].modificationDate)
            return cellView
        }
        else if tableColumn == filesTableView.tableColumns[CellIndex.ConvertStatusCell] {
            let cellView = filesTableView.makeView(withIdentifier:CellIdentifiers.ConvertStatusCell, owner: nil) as? NSTableCellView
            cellView?.textField?.stringValue = convertStatuses[row].rawValue
            return cellView
        }
        
        return nil
    }
}
