//
//  CourseViewController.swift
//  Siding
//
//  Created by Nicolás Gebauer on 02-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {
    
    enum TableSection: Int {
        case CourseData = 0, CourseFolder = 1
        
        static func numberOfSections() -> Int { return 2 }
    }
    
    enum CourseDataRow: Int {
        case News = 0, Program = 1, Calendar = 2, Forms = 3, Students = 4, Grades = 5, Forum = 6
        
        static func numberOfRows() -> Int { return 6 }
        func name() -> String {
            switch self {
            case .News:
                return "Avisos"
            case .Program:
                return "Programa"
            case .Calendar:
                return "Calendario"
            case .Forms:
                return "Cuestionarios"
            case .Students:
                return "Alumnos"
            case .Grades:
                return "Notas"
            case .Forum:
                return "Foro"
            }
        }
    }
    
    // MARK: - Constants

    // MARK: - Variables
    
    var model: CourseViewModel?
    
    // MARK: - Outlets
    
    @IBOutlet weak var courseTable: UITableView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = model?.course.name ?? "ERROR_COURSE_NAME"
        courseTable.delegate = self
        courseTable.dataSource = self
        courseTable.tableFooterView = UIView()
        model?.load()
        toastLoading()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    
    // MARK: - Functions

    func configureFromSegue(courseModel: CourseViewModel) {
        model = courseModel
        model?.delegate = self
    }
}

// MARK: - CourseViewModelDelegate conform
extension CourseViewController: CourseViewModelDelegate {
    
    func loadedFiles() {
        mainQueue({
            self.toastLoadingFinished()
            self.courseTable.reloadData()
        })
    }
}

// MARK: - UITableViewDelegate conform
extension CourseViewController: UITableViewDelegate {
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // TODO: Add alpha to color
        let color = UIColor.grayColor()
        view.tintColor = color
    }
 
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let section = TableSection(rawValue: indexPath.section) else { return 0 }
        switch section {
        case .CourseData:
            return 45
        case .CourseFolder:
            return 60
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        courseTable.deselectRowAtIndexPath(indexPath, animated: true)
//        guard let model = model else { return }
//        let course = model.courses[indexPath.row]
//        performSegueWithIdentifier(R.segue.sidingViewController.showCourse, sender: course)
    }
}

// MARK: - UITableViewDataSource conform
extension CourseViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TableSection.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model, let section = TableSection(rawValue: section) else { return 0 }
        switch section {
        case .CourseData:
            return CourseDataRow.numberOfRows()
        case .CourseFolder:
            return model.files.count
        }
//        return model.courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let model = model, let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .CourseData:
            guard let dataRow = CourseDataRow(rawValue: indexPath.row) else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.courseDataCell.identifier) as! CourseDataCell
            cell.configure(dataRow)
            return cell
        case .CourseFolder:
            let file = model.files[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.courseFileCell.identifier) as! CourseDataCell
            cell.configure(file)
            return cell
        }
//        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.courseCell.identifier) as! CourseCell
//        cell.config(model.courses[indexPath.row])
//        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = TableSection(rawValue: section) else { return "" }
        switch section {
        case .CourseData:
            return "Información del curso"
        case .CourseFolder:
            return "Archivos del curso"
        }
    }
    
//    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return "asd"
//    }
}