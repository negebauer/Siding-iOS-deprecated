//
//  CourseCell.swift
//  Siding
//
//  Created by Nicolás Gebauer on 02-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {
    
    // MARK: - Constants

    // MARK: - Variables
    
    // MARK: - Outlets
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var section: UILabel!
    
    // MARK: - Init

    // MARK: - Actions
    
    // MARK: - Functions
    
    func config(_ course: Course) {
        name.text = "\(course.id) \(course.name)"
        section.text = "Seccion \(course.section)"
    }

}
