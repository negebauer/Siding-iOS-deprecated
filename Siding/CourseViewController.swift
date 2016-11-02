//
//  CourseViewController.swift
//  Siding
//
//  Created by Nicolás Gebauer on 02-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit
import MBProgressHUD

class CourseViewController: UIViewController, ProgressHUDContainer {
    
    enum TableSection: Int {
        case courseData = 0, courseFolder = 1
        
        static func numberOfSections() -> Int { return 2 }
    }
    
    enum CourseDataRow: Int {
        case news = 0, program = 1, calendar = 2, forms = 3, students = 4, grades = 5, forum = 6
        
        static func numberOfRows() -> Int { return 6 }
        func name() -> String {
            switch self {
            case .news:
                return "Avisos"
            case .program:
                return "Programa"
            case .calendar:
                return "Calendario"
            case .forms:
                return "Cuestionarios"
            case .students:
                return "Alumnos"
            case .grades:
                return "Notas"
            case .forum:
                return "Foro"
            }
        }
    }
    
    // MARK: - Constants

    // MARK: - Variables
    
    var model: CourseViewModel?
    var hud: MBProgressHUD?
    
    // MARK: - Outlets
    
    @IBOutlet weak var courseTable: UITableView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courseTable.delegate = self
        courseTable.dataSource = self
        courseTable.tableFooterView = UIView()
        guard let model = model else { return }
        navigationItem.title = model.course.name
        model.load()
        showLoadingHUD("Cargando curso")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    
    // MARK: - Functions

    func configureFromSegue(_ courseModel: CourseViewModel) {
        model = courseModel
        model?.delegate = self
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let model = model else { return }
        model.prepareForSegue(segue, sender: sender)
    }
}

// MARK: - CourseViewModelDelegate conform
extension CourseViewController: CourseViewModelDelegate {
    
    func loadedFiles() {
        mainQueue({
            self.dismissLoadingHUD()
            self.courseTable.reloadData()
        })
    }
    
    func loadedStudents(_ model: CourseViewModel) {
        // TODO: Show the students
    }
}

// MARK: - UITableViewDelegate conform
extension CourseViewController: UITableViewDelegate {
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // TODO: Add alpha to color
        let color = UIColor.gray
        view.tintColor = color
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = TableSection(rawValue: (indexPath as NSIndexPath).section) else { return 0 }
        switch section {
        case .courseData:
            return 45
        case .courseFolder:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        courseTable.deselectRow(at: indexPath, animated: true)
        guard let model = model, let section = TableSection(rawValue: (indexPath as NSIndexPath).section) else { return }
        switch section {
        case .courseData:
            guard let row = CourseDataRow(rawValue: (indexPath as NSIndexPath).row) else { return }
            switch row {
            case .students:
                model.loadStudents()
            default:
                break
            }
        case .courseFolder:
            let file = model.files[indexPath.row]
            performSegue(withIdentifier: R.segue.courseViewController.showCourseFolder, sender: file)
        }
    }
}

// MARK: - UITableViewDataSource conform
extension CourseViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model, let section = TableSection(rawValue: section) else { return 0 }
        switch section {
        case .courseData:
            return CourseDataRow.numberOfRows()
        case .courseFolder:
            return model.files.count
        }
//        return model.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model, let section = TableSection(rawValue: (indexPath as NSIndexPath).section) else { return UITableViewCell() }
        switch section {
        case .courseData:
            guard let dataRow = CourseDataRow(rawValue: (indexPath as NSIndexPath).row) else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.courseDataCell.identifier) as! CourseDataCell
            cell.configure(dataRow)
            return cell
        case .courseFolder:
            let file = model.files[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.courseFileCell.identifier) as! CourseDataCell
            cell.configure(file)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = TableSection(rawValue: section) else { return "" }
        switch section {
        case .courseData:
            return "Información del curso"
        case .courseFolder:
            return "Archivos del curso"
        }
    }
}
