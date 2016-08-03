//
//  File.swift
//  Siding
//
//  Created by Nicolás Gebauer on 02-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UCSiding

class File: UCSFile {
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - Init
    
    init(file: UCSFile) {
        super.init(course: file.course, filename: file.name, path: file.path, url: file.url, idSidingFolder: file.idSidingFolder, idSidingFile: file.idSidingFile)
    }
    
    // MARK: - Functions

}