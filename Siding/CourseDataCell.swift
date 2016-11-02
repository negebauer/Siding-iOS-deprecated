//
//  CourseDataCell.swift
//  Siding
//
//  Created by Nicolás Gebauer on 07-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit
import UCSiding

class CourseDataCell: UITableViewCell {
    
    // MARK: - Constants

    // MARK: - Variables
    
    var file: UCSFile?
    
    // MARK: - Outlets
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileTypeLabel: UILabel!
    @IBOutlet weak var comingSoonLabel: UILabel!
    
    // MARK: - Init

    // MARK: - Actions
    
    // MARK: - Functions
    
    func configure(_ file: UCSFile) {
        self.file = file
        fileNameLabel.text = file.name
        if (file.isFolder()) {
            fileTypeLabel.text = "Carpeta"
        } else {
            fileTypeLabel.text = file.fileExtension()
        }
    }
    
    func configure(_ data: CourseViewController.CourseDataRow) {
        dataLabel.text = data.name()
        comingSoonLabel.isHidden = false
    }
    
    // MARK: - Navigation

}
