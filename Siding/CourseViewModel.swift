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
        // TODO: Move hierarchy to library?
        /*
         Maybe use a dictionary [path: folder] to finde parents by checking if the path is contained in file.path
         Then on addChild do the same check to see if parent is a folder child
         
         Or on UCSiding expose method to scrap one page at a time. First the main one with all the folders and then just the content of the a given page (the middle part)
         */
        
        print(file.path + " - " + file.name)
        if file.name == "t1_respuesta1.pdf" {
            print("a")
        }
        guard !files.contains({ $0.idSidingFolder ?? " " == file.idSidingFolder || $0.idSidingFile ?? " " == file.idSidingFile }) else { return }
        var parent: Folder?
        let parents = files.filter({ $0.path + "/" + $0.name == file.path && $0 is Folder }).map({ $0 as? Folder })
        if parents.count > 0 {
            parent = parents[0]
        }
        let newFile: File
        if file.isFolder() {
            newFile = Folder(file: file)
        } else {
            newFile = File(file: file)
        }
        guard let parentFolder = parent else {
            _files.append(newFile)
            delegate?.updateTable()
            return
        }
        parentFolder.addChild(newFile)
    }
}