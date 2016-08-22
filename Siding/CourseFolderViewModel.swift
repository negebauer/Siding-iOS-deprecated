//
//  CourseFolderViewModel.swift
//  Siding
//
//  Created by Nicolás Gebauer on 09-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UCSiding

protocol CourseFolderViewModelDelegate: class {
    func loadedFiles()
    func downloadedFile(fileURL: NSURL) // TODO: Save file data to device
}

class CourseFolderViewModel {
    
    // MARK: - Constants

    let folder: UCSFile
    let session: UCSSession
    private let _course: Course
    
    // MARK: - Variables
    
    weak var delegate: CourseFolderViewModelDelegate?
    var course: Course { return _course }
    private var _files: [UCSFile] = []
    var files: [UCSFile] { return _files }
    var hasLoadedFiles = false
    
    // MARK: - Init
    
    init(course: Course, folder: UCSFile, session: UCSSession) {
        self._course = course
        self.folder = folder
        self.session = session
        course.delegate = self
        _files = folder.childs
    }
    
    // MARK: - Functions

    func load() {
        course.loadFolderFiles(folder)
    }
    
    func download(file: UCSFile) {
        // TODO: Download the file
        // TODO: See if file was recently downloaded?
    }
}

// MARK: - UCSCourseDelegate conform
extension CourseFolderViewModel: UCSCourseDelegate {
    
    func foundFile(course: UCSCourse, file: UCSFile) {
        // Don't do anything. We want to have all files
    }
    
    func foundMainFiles(course: UCSCourse, files: [UCSFile]) {
        // We won't find this here
    }
    
    func foundFolderFiles(course: UCSCourse, folder: UCSFile, files: [UCSFile]) {
        _files = files
        hasLoadedFiles = true
        delegate?.loadedFiles()
    }
}