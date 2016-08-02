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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    
    // MARK: - Functions

    func configureFromSegue(courseModel: CourseViewModel) {
        model = courseModel
    }
}

// MARK: - CourseViewModelDelegate conform
extension CourseViewController: CourseViewModelDelegate {
    
    func updateTable() {
        // TODO:
    }
}

// MARK: - UITableViewDelegate conform
extension CourseViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
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
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model, let section = TableSection(rawValue: section) else { return 0 }
        switch section {
        case .CourseData:
            break
        case .CourseFolder:
            break
        }
        return 0
//        return model.courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let model = model, let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .CourseData:
            break
        case .CourseFolder:
            break
        }
//        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.courseCell.identifier) as! CourseCell
//        cell.config(model.courses[indexPath.row])
//        return cell
        return UITableViewCell()
    }
}