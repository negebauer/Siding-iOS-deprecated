//
//  CourseViewModel.swift
//  Siding
//
//  Created by Nicolás Gebauer on 02-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UCSiding

protocol CourseViewModelDelegate: class {
    func loadedFiles()
}

class CourseViewModel {
    
    // MARK: - Constants

    let session: UCSSession
    weak var delegate: CourseViewModelDelegate?
    private let _course: Course
    var course: Course { return _course }
    private var _files: [File] = []
    var files: [File] { return _files }
    
    // MARK: - Variables
    
    // MARK: - Init
    
    init(course: Course, session: UCSSession) {
        _course = course
        self.session = session
        course.delegate = self
    }
    
    // MARK: - Functions

    func load() {
        course.loadFiles()
    }
}


// MARK: - UCSCourseDelegate conform
extension CourseViewModel: UCSCourseDelegate {
    
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