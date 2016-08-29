//
//  SidingViewController.swift
//  Siding
//
//  Created by Nicolás Gebauer on 01-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit
import UCSiding
import GoogleMobileAds
import MBProgressHUD

class SidingViewController: UIViewController, ProgressHUDContainer {
    
    enum TableSection: Int {
        case Courses = 0
        
        static func numberOfSections() -> Int { return 1 }
    }
    
    // MARK: - Constants

    // MARK: - Variables
    
    var model: SidingViewModel?
    var isLogin = false
    var loginCooldown: NSTimer?
    var hud: MBProgressHUD?
    
    // MARK: - Outlets
    
    @IBOutlet weak var sidingTable: UITableView!
    @IBOutlet weak var adBanner: GADBannerView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sidingTable.delegate = self
        sidingTable.dataSource = self
        sidingTable.tableFooterView = UIView()
        login(false)
        
        // Google ad banner
        adBanner.adUnitID = "ca-app-pub-8882180510797099/5756826366"
        adBanner.rootViewController = self
        let request = GADRequest()
        #if DEBUG
            request.testDevices = [ kGADSimulatorID ]
        #endif
        adBanner.loadRequest(request)
    }
    
    override func viewDidAppear(animated: Bool) {
        login(true)
    }
    
    // MARK: - Actions
    
    @IBAction func logout(sender: AnyObject) {
        ActivityIndicator.shared.kill()
        dismissLoadingHUD()
        isLogin = false
        Settings.instance.deleteData()
        login(true, reload: true)
    }
    
    @IBAction func reload(sender: AnyObject) {
        guard !isLogin && loginCooldown == nil else { return }
        loginCooldown = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(loginCooldownCompleted), userInfo: nil, repeats: false)
        ActivityIndicator.shared.kill()
        login(true, reload: true)
    }
    
    @IBAction func nameTap(sender: AnyObject) {
        performSegueWithIdentifier(R.segue.sidingViewController.showAppInfo, sender: nil)
    }
    
    // MARK: - Functions
    
    func loginCooldownCompleted() {
        loginCooldown?.invalidate()
        loginCooldown = nil
    }
    
    func login(viewAppeared: Bool, reload: Bool = false) {
        guard !isLogin else { return }
        let cancelLogin = { self.isLogin = false }
        isLogin = true
        dismissLoadingHUD()
        if reload {
            model = nil
            sidingTable.reloadData()
        }
        guard Settings.instance.isUserSet() else {
            if viewAppeared { configureCredentials(viewAppeared, reload: reload) }
            return cancelLogin()
        }
        guard model == nil else { return cancelLogin() }
        showLoadingHUD("Ingresando")
        model = SidingViewModel(username: Settings.instance.username, password: Settings.instance.password)
        model!.delegate = self
        model!.login()
    }
    
    func configureCredentials(viewAppeared: Bool, reload: Bool = false) {
        let alert = UIAlertController(title: "Credenciales uc 🔑", message: "", preferredStyle: .Alert)
        // alert.addAction(AlertAction.cancelAction())
        alert.addAction(AlertAction.alertAction("Log in") {
            let username = alert.textFields?[0].text ?? ""
            let password = alert.textFields?[1].text ?? ""
            Settings.instance.configure(username, password: password)
                self.login(viewAppeared, reload: reload)
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
    
    func showErrorAlert(title: String = "Error", message: String, retry: (() -> Void)? = nil, ok: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(AlertAction.okAction({ _ in ok?() }))
        alert.addAction(AlertAction.retryAction(retry))
        presentViewController(alert, animated: true, completion: nil)
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
        dismissLoadingHUD()
        isLogin = false
        switch result {
        case .Success:
            model.loadSiding()
        case .Error(let reason):
            showErrorAlert("Error login", message: reason, retry: { self.login(true, reload: true) },
                           ok: { self.configureCredentials(true, reload: true) })
        }
    }
    
    func updateSidingTable() {
        mainQueue({ self.sidingTable.reloadData() })
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TableSection.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model, let section = TableSection(rawValue: section) else { return 0 }
        switch section {
        case .Courses:
            return model.courses.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let model = model, let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .Courses:
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.courseCell.identifier) as! CourseCell
            cell.config(model.courses[indexPath.row])
            return cell
        }
    }
}