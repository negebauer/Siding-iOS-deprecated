//
//  Folder.swift
//  Siding
//
//  Created by Nicolás Gebauer on 02-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UCSiding

class Folder: File {
    
    // MARK: - Constants

    // MARK: - Variables
    
    private var _files: [File] = []
    var files: [File] = []
    
    // MARK: - Init
    
    // MARK: - Functions
    
    func addChild(file: File) {
        _files.append(file)
    }

}