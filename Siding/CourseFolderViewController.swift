//
//  CourseFolderViewController.swift
//  Siding
//
//  Created by Nicolás Gebauer on 09-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit
import MBProgressHUD

class CourseFolderViewController: UIViewController, ProgressHUDContainer {
    
    // MARK: - Constants

    // MARK: - Variables
    
    var model: CourseFolderViewModel?
    var fileOpenCell: CourseDataCell?
    var hud: MBProgressHUD?
    
    // MARK: - Outlets
    
    @IBOutlet weak var folderTable: UITableView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        folderTable.delegate = self
        folderTable.dataSource = self
        folderTable.tableFooterView = UIView()
        guard let model = model else { return }
        navigationItem.title = model.folder.name
        model.load()
        showLoadingHUD("Cargando archivos")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    // MARK: - Actions
    
    // MARK: - Functions
    
    func configureFromSegue(_ folderModel: CourseFolderViewModel) {
        model = folderModel
        model?.delegate = self
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

// MARK: - CourseViewModelDelegate conform
extension CourseFolderViewController: CourseFolderViewModelDelegate {
    
    func loadedFiles() {
        mainQueue({
            self.dismissLoadingHUD()
            self.folderTable.reloadData()
        })
    }
    
    func downloadedFile(_ fileURL: URL) {
        dismissLoadingHUD()
        let fileViewController = UIDocumentInteractionController(url: fileURL)
        fileViewController.delegate = self
        mainQueue({
            fileViewController.presentPreview(animated: true)
        })
    }
    
    func downloadFileProgress(_ progress: Float) {
        mainQueue({
            self.hud?.progress = progress
        })
    }
}

// MARK: - UITableViewDelegate conform
extension CourseFolderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        folderTable.deselectRow(at: indexPath, animated: true)
        guard let model = model else { return }
        let file = model.files[indexPath.row]
        
        if file.isFolder() {
            guard let vc = storyboard?.instantiateViewController(R.storyboard.main.courseFolderDetail) else { return }
            let model = CourseFolderViewModel(course: model.course, folder: file, session: model.session)
            vc.configureFromSegue(model)
            navigationController?.pushViewController(vc, animated: true)
        } else if file.isFile() {
            guard let cell = folderTable.cellForRow(at: indexPath) as? CourseDataCell else { return }
            fileOpenCell = cell
            showLoadingHUD("Descargando")
            model.download(file)
        }
    }
}

// MARK: - UITableViewDataSource conform
extension CourseFolderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model else { return 0 }
        return model.files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.courseFileCell.identifier) as! CourseDataCell
        cell.configure(model.files[indexPath.row])
        return cell
    }
}

// MARK: - UIDocumentInteractionController comply
extension CourseFolderViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController{
        return navigationController ?? self
    }
}
