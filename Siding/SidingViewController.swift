//
//  SidingViewController.swift
//  Siding
//
//  Created by Nicolás Gebauer on 01-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit
import UCSiding

class SidingViewController: UIViewController {
    
    // MARK: - Constants

    // MARK: - Variables
    
    var model: SidingViewModel?
    var loading = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var sidingTable: UITableView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sidingTable.delegate = self
        sidingTable.dataSource = self
        login(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        login(true)
    }
    
    // MARK: - Actions
    
    @IBAction func logout(sender: AnyObject) {
        Settings.instance.deleteData()
        login(true, reload: true)
    }
    
    @IBAction func reload(sender: AnyObject) {
        guard Settings.instance.isUserSet() else { return }
        login(true, reload: true)
    }
    
    @IBAction func nameTap(sender: AnyObject) {
        print("❤️")
    }
    
    // MARK: - Functions
    
    func loadingFinished() {
        loading = false
        toastLoadingFinished()
    }
    
    func loadingStarted() {
        loading = true
        toastLoading()
    }
    
    func login(viewAppeared: Bool, reload: Bool = false) {
        if reload {
            loadingFinished()
            model = nil
            sidingTable.reloadData()
        }
        guard !loading else { return }
        guard Settings.instance.isUserSet() else {
            if viewAppeared { configureCredentials(viewAppeared) }
            return
        }
        guard model == nil else { return }
        model = SidingViewModel(username: Settings.instance.username, password: Settings.instance.password)
        model!.delegate = self
        loadingStarted()
        model!.login()
    }
    
    func configureCredentials(viewAppeared: Bool) {
        let alert = UIAlertController(title: "Credenciales uc 🔑", message: "", preferredStyle: .Alert)
        alert.addAction(AlertAction.cancelAction())
        alert.addAction(AlertAction.alertAction("Log in") {
            let username = alert.textFields?[0].text ?? ""
            let password = alert.textFields?[1].text ?? ""
            Settings.instance.configure(username, password: password)
                self.login(viewAppeared)
            })
        alert.addTextFieldWithConfigurationHandler() {
            $0.placeholder = "Usuario sin @uc"
            $0.text = Settings.instance.username
        }
        alert.addTextFieldWithConfigurationHandler() {
            $0.placeholder = "Contraseña"
            $0.secureTextEntry = true
            $0.text = Settings.instance.password
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(title: String = "Error", message: String, retry: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(AlertAction.okAction())
        alert.addAction(AlertAction.retryAction(retry))
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let model = model else { return }
        model.prepareForSegue(segue, sender: sender)
    }
    
}

// MARK: - SidingViewModelDelegate conform
extension SidingViewController: SidingViewModelDelegate {
    
    func loadedSiding(model: SidingViewModel, result: LoginResult) {
        loadingFinished()
        switch result {
        case .Success:
            model.loadSiding()
        case .Error(let reason):
            showErrorAlert("Error login", message: reason, retry: { self.login(true, reload: true) })
        }
    }
    
    func updateSidingTable() {
        sidingTable.reloadData()
    }
}

// MARK: - UITableViewDelegate conform
extension SidingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        sidingTable.deselectRowAtIndexPath(indexPath, animated: true)
        guard let model = model else { return }
        let course = model.courses[indexPath.row]
        performSegueWithIdentifier(R.segue.sidingViewController.showCourse, sender: course)
    }
}

// MARK: - UITableViewDataSource conform
extension SidingViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model else { return 0 }
        return model.courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let model = model else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.courseCell.identifier) as! CourseCell
        cell.config(model.courses[indexPath.row])
        return cell
    }
}