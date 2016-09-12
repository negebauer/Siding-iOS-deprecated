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
    func downloadFileProgress(_ progress: Float)
    func downloadedFile(_ fileURL: NSURL)
}

class CourseFolderViewModel {
    
    // MARK: - Constants

    let folder: UCSFile
    let session: UCSSession
    fileprivate let _course: Course
    
    // MARK: - Variables
    
    weak var delegate: CourseFolderViewModelDelegate?
    var course: Course { return _course }
    fileprivate var _files: [UCSFile] = []
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
    
    func download(_ file: UCSFile) {
        file.download(session.headers(), delegate: self)
    }
}

// MARK: - UCSCourseDelegate conform
extension CourseFolderViewModel: UCSCourseDelegate {
    
    func foundFile(_ course: UCSCourse, file: UCSFile) {
        // Don't do anything. We want to have all files
    }
    
    func foundMainFiles(_ course: UCSCourse, files: [UCSFile]) {
        // We won't find this here
    }
    
    func foundFolderFiles(_ course: UCSCourse, folder: UCSFile, files: [UCSFile]) {
        _files = files
        hasLoadedFiles = true
        delegate?.loadedFiles()
    }
}

// MARK: - UCSFileDelegate comply
extension CourseFolderViewModel: UCSFileDelegate {
    
    func downloadProgress(_ progress: Float) {
        delegate?.downloadFileProgress(progress)
    }
    
    func downloadFinished(_ fileURL: NSURL) {
        delegate?.downloadedFile(fileURL)
    }
}
