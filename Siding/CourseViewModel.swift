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
    private let _course: Course
    
    // MARK: - Variables
    
    weak var delegate: CourseViewModelDelegate?
    var course: Course { return _course }
    private var _files: [File] = []
    var files: [File] { return _files }
    
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
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let id = segue.identifier else { return }
        switch id {
        case R.segue.courseViewController.showCourseFolder.identifier:
            guard let file = sender as? File, folderView = segue.destinationViewController as? CourseFolderViewController else {
                return
            }
            let model = CourseFolderViewModel(course: course, file: file, session: session)
            folderView.configureFromSegue(model)
        default:
            break
        }
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