//
//  SidingViewModel.swift
//  Siding
//
//  Created by Nicolás Gebauer on 01-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UCSiding

enum LoginResult {
    case success
    case error(description: String)
}

protocol SidingViewModelDelegate: class {
    func loadedSiding(_ model: SidingViewModel, result: LoginResult)
    func updateSidingTable()
}

class SidingViewModel {
    
    // MARK: - Constants
    
    fileprivate let session: UCSSession
    fileprivate let siding: UCSiding
    
    // MARK: - Variables
    
    internal weak var delegate: SidingViewModelDelegate?
    var _courses: [Course] = []
    var courses: [Course] { return _courses }
    
    // MARK: - Init
    
    init(username: String, password: String) {
        session = UCSSession(username: username, password: password)
        siding = UCSiding(session: session)
        siding.delegate = self
    }
    
    // MARK: - Functions

    func login() {
        session.login({
            self.delegate?.loadedSiding(self, result: .Success)
            }, failure: { error in
                let error = error != nil ? "\n\n\(error!.localizedDescription)" : ""
                let description = "No se pudo iniciar sesión\nRevisa que ingresaste correctamente tus datos e inténtalo de nuevo\(error)"
                self.delegate?.loadedSiding(self, result: .Error(description: description))
        })
    }
    
    func loadSiding() {
        siding.loadCourses()
    }
    
    func prepareForSegue(_ segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let id = segue.identifier else { return }
        switch id {
        case R.segue.sidingViewController.showCourse.identifier:
            guard let course = sender as? Course, let courseView = segue.destinationViewController as? CourseViewController else {
                return
            }
            let model = CourseViewModel(course: course, session: session)
            courseView.configureFromSegue(model)
        default:
            break
        }
    }
}

// MARK: UCSidingDelegate conform
extension SidingViewModel: UCSidingDelegate {
    
    func coursesFound(_ siding: UCSiding, courses: [UCSCourse]) {
        courses.forEach({ course in
            let course = Course(course: course)
            self._courses.append(course)
        })
        delegate?.updateSidingTable()
    }
    
    func courseFoundFile(_ siding: UCSiding, courses: [UCSCourse], course: UCSCourse, file: UCSFile) {
        
    }
    
}
