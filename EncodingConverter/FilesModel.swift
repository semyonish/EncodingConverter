
//
//  FilesModel.swift
//  EncodingConverter
//
//  Created by Семён Ишханян on 24.05.2020.
//  Copyright © 2020 Семён Ишханян. All rights reserved.
//

import Foundation

protocol FilesModelDelegate: NSObject {
    func updateUI()
}

class FilesModel
{
    weak var delegate: FilesModelDelegate!
    
    // MARK: - private fields
    private var openedFolderUrl = URL(fileURLWithPath: "/")
    
    private var filesMetadata = [FileMetadata]()
    
    private var filesSortKey = FileMetadataOrderKey.name
    private var sortAscending = false
    
    // MARK: - public methods
    public func setFolderUrl(_ newUrl: URL) {
        openedFolderUrl = newUrl
        reloadFiles()
    }
    
    public func openFolderWith(row: Int) {
        let folder = filesMetadata[row]
        if !folder.isDirectory {
            print("Error: try to open \(folder.name) as folder")
            return
        }
        
        print("Log: open folder with url = \(folder.url)")
        setFolderUrl(folder.url)
    }
    
    public func getFiles() -> [FileMetadata] {
        return filesMetadata
    }
    
    public func getFilesCount() -> Int {
        return filesMetadata.count
    }
    
    public func setSortParameters(key: FileMetadataOrderKey, ascending: Bool) {
        filesSortKey = key
        sortAscending = ascending
        sortFiles()
        delegate.updateUI()
    }
    
    public func encodeFiles(from selectedIndexes: IndexSet, toEncodingWithName encodingName: String) -> Dictionary<Int, Bool> {
        var result = [Int:Bool]()
        
        guard let encoding =  FileEncoding.init(rawValue: encodingName) else {
            print("Error: undefined encoding name: \(encodingName)")
            return result
        }
        
        for index in  selectedIndexes {
            result[index] = FileEncoder.encode(file: filesMetadata[index].url, to: encoding)
        }
        
        return result
    }
    
    public func reloadFiles() {
        filesMetadata = FileLoader.loadFiles(from: openedFolderUrl)
        sortFiles()
        delegate.updateUI()
    }
    
    public func refreshEncodings() {
        for i in filesMetadata.indices {
            filesMetadata[i].encoding = FileEncoder.getEncoding(of: filesMetadata[i].url)
        }
        
        delegate.updateUI()
    }
    
    // MARK: - private methods
    private func sortFiles() {
        switch filesSortKey {
        case .name:
            filesMetadata.sort { itemCompare(lhs: $0.name, rhs: $1.name, ascending: sortAscending) }
        case .modificationDate:
            filesMetadata.sort { itemCompare(lhs: $0.modificationDate, rhs: $1.modificationDate, ascending: sortAscending) }
        }
    }
    
}
