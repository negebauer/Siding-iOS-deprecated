//
//  CourseDataCell.swift
//  Siding
//
//  Created by Nicolás Gebauer on 07-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit

class CourseDataCell: UITableViewCell {
    
    // MARK: - Constants

    // MARK: - Variables
    
    var file: File?
    
    // MARK: - Outlets
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileTypeLabel: UILabel!
    
    // MARK: - Init

    // MARK: - Actions
    
    // MARK: - Functions
    
    func configure(file: File) {
        self.file = file
        fileNameLabel.text = file.name
        if file.isFolder() {
            fileTypeLabel.text = "Carpeta"
        } else {
            fileTypeLabel.text = file.fileExtension()
        }
    }
    
    func configure(data: CourseViewController.CourseDataRow) {
        dataLabel.text = data.name()
    }
    
    // MARK: - Navigation

}