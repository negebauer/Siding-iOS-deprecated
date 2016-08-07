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
    
    // MARK: - Constants

    // MARK: - Variables
    
    var model: CourseViewModel?
    
    // MARK: - Outlets
    
    @IBOutlet weak var courseTable: UITableView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = model?.course.name
        courseTable.delegate = self
        courseTable.dataSource = self
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
//        return 0
//    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        sidingTable.deselectRowAtIndexPath(indexPath, animated: true)
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
            return 0
        case .CourseFolder:
            return model.files.count
        }
//        return model.courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let model = model, let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .CourseData:
            return UITableViewCell()
        case .CourseFolder:
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "")
            cell.textLabel?.text = model.files[indexPath.row].name
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
}