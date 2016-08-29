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
    func loadedStudents(model: CourseViewModel)
}

class CourseViewModel {
    
    // MARK: - Constants

    let session: UCSSession
    private let _course: Course
    
    // MARK: - Variables
    
    weak var delegate: CourseViewModelDelegate?
    var course: Course { return _course }
    private var _files: [UCSFile] = []
    var files: [UCSFile] { return _files }
    var hasLoadedFiles = false
    
    var students: [UCSStudent] = []
    
    // MARK: - Init
    
    init(course: Course, session: UCSSession) {
        _course = course
        self.session = session
        course.delegate = self
        _files = course.mainFiles
    }
    
    // MARK: - Functions

    func load() {
        guard !hasLoadedFiles else { return }
        course.loadMainFiles()
    }
    
    func loadStudents() {
        course.loadStudents(true, success: { students in
            self.students = students
            self.delegate?.loadedStudents(self)
            }, failure: { error in
                
        })
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let id = segue.identifier else { return }
        switch id {
        case R.segue.courseViewController.showCourseFolder.identifier:
            guard let file = sender as? UCSFile, folderView = segue.destinationViewController as? CourseFolderViewController else {
                return
            }
            let model = CourseFolderViewModel(course: course, folder: file, session: session)
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
        _files = files
        hasLoadedFiles = true
        delegate?.loadedFiles()
    }
    
    func foundFolderFiles(course: UCSCourse, folder: UCSFile, files: [UCSFile]) {
        // We won't find this here
    }
}