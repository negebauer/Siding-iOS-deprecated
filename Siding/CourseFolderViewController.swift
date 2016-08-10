//
//  CourseFolderViewController.swift
//  Siding
//
//  Created by Nicolás Gebauer on 09-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit

class CourseFolderViewController: UIViewController {
    
    // MARK: - Constants

    // MARK: - Variables
    
    var model: CourseFolderViewModel?
    var fileOpenCell: CourseDataCell?
    
    // MARK: - Outlets
    
    @IBOutlet weak var folderTable: UITableView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        folderTable.delegate = self
        folderTable.dataSource = self
        folderTable.tableFooterView = UIView()
        model?.load()
        toastLoading()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }

    // MARK: - Actions
    
    // MARK: - Functions
    
    func configureFromSegue(folderModel: CourseFolderViewModel) {
        model = folderModel
        model?.delegate = self
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}

// MARK: - CourseViewModelDelegate conform
extension CourseFolderViewController: CourseFolderViewModelDelegate {
    
    func loadedFiles() {
        mainQueue({
            self.toastLoadingFinished()
            self.folderTable.reloadData()
        })
    }
    
    func downloadedFile(fileURL: NSURL) {
        // TODO: Show
        guard let cell = fileOpenCell else { return }
        let fileViewController = UIDocumentInteractionController(URL: fileURL)
        fileViewController.presentOptionsMenuFromRect(cell.frame, inView: view, animated: true)
    }
}

// MARK: - UITableViewDelegate conform
extension CourseFolderViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        folderTable.deselectRowAtIndexPath(indexPath, animated: true)
        guard let model = model else { return }
        let file = model.files[indexPath.row]
        
        if file.isFolder() {
            guard let vc = storyboard?.instantiateViewController(R.storyboard.main.courseFolderDetail) else { return }
            vc.model = CourseFolderViewModel(course: model.course, file: file, session: model.session)
            navigationController?.pushViewController(vc, animated: true)
        } else if file.isFile() {
            guard let cell = folderTable.cellForRowAtIndexPath(indexPath) as? CourseDataCell else { return }
            fileOpenCell = cell
            model.download(file)
        }
    }
}

// MARK: - UITableViewDataSource conform
extension CourseFolderViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model else { return 0 }
        return model.files.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let model = model else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.courseFileCell.identifier) as! CourseDataCell
        cell.configure(model.files[indexPath.row])
        return cell
    }
}