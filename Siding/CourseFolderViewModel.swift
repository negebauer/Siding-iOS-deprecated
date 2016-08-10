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
    func downloadedFile()
}

class CourseFolderViewModel {
    
    // MARK: - Constants

    let file: File
    let session: UCSSession
    private let _course: Course
    
    // MARK: - Variables
    
    weak var delegate: CourseFolderViewModelDelegate?
    var course: Course { return _course }
    private var _files: [File] = []
    var files: [File] { return _files }
    
    // MARK: - Init
    
    init(course: Course, file: File, session: UCSSession) {
        self._course = course
        self.file = file
        self.session = session
        course.delegate = self
    }
    
    // MARK: - Functions

    func load() {
        course.loadFolderFiles(file)
    }
    
    func download(file: File) {
        // TODO: Download the file
    }
}

// MARK: - UCSCourseDelegate conform
extension CourseFolderViewModel: UCSCourseDelegate {
    
    func foundFile(course: UCSCourse, file: UCSFile) {
        // Don't do anything. We want to have all files
    }
    
    func foundMainFiles(course: UCSCourse, files: [UCSFile]) {
        _files.removeAll()
        files.forEach({
            let newFile = File(file: $0)
            self._files.append(newFile)
        })
        delegate?.loadedFiles()
    }
    
    func foundFolderFiles(course: UCSCourse, folder: UCSFile, files: [UCSFile]) {
        // We won't find this here
    }
}