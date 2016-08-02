//
//  Course.swift
//  Siding
//
//  Created by Nicolás Gebauer on 02-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UCSiding

class Course: UCSCourse {
    
    // MARK: - Constants

    // MARK: - Variables
    
    // MARK: - Init
    
    init(course: UCSCourse) {
        super.init(id: course.id, idSiding: course.idSiding, name: course.name, url: course.url, section: course.section)
    }
    
    // MARK: - Functions

}