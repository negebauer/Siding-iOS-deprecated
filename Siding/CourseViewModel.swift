//
//  CourseViewModel.swift
//  Siding
//
//  Created by Nicolás Gebauer on 02-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UCSiding

protocol CourseViewModelDelegate: class {
    func updateTable()
}

class CourseViewModel {
    
    // MARK: - Constants

    let session: UCSSession
    private let _course: Course
    var course: Course { return _course }
    
    // MARK: - Variables
    
    // MARK: - Init
    
    init(course: Course, session: UCSSession) {
        _course = course
        self.session = session
    }
    
    // MARK: - Functions

}


// MARK: - UCSCourseDelegate conform
extension CourseViewModel: UCSCourseDelegate {
    
    func foundFile(course: UCSCourse, file: UCSFile) {
        // TODO:
    }
}