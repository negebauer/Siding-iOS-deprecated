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
        case courses = 0
        
        static func numberOfSections() -> Int { return 1 }
    }
    
    // MARK: - Constants

    // MARK: - Variables
    
    var model: SidingViewModel?
    var isLogin = false
    var loginCooldown: Timer?
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
        adBanner.load(request)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        login(true)
    }
    
    // MARK: - Actions
    
    @IBAction func logout(_ sender: AnyObject) {
        ActivityIndicator.shared.kill()
        dismissLoadingHUD()
        isLogin = false
        Settings.instance.deleteData()
        login(true, reload: true)
    }
    
    @IBAction func reload(_ sender: AnyObject) {
        guard !isLogin && loginCooldown == nil else { return }
        loginCooldown = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(loginCooldownCompleted), userInfo: nil, repeats: false)
        ActivityIndicator.shared.kill()
        login(true, reload: true)
    }
    
    @IBAction func nameTap(_ sender: AnyObject) {
        performSegue(withIdentifier: R.segue.sidingViewController.showAppInfo, sender: nil)
    }
    
    // MARK: - Functions
    
    func loginCooldownCompleted() {
        loginCooldown?.invalidate()
        loginCooldown = nil
    }
    
    func login(_ viewAppeared: Bool, reload: Bool = false) {
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
    
    func configureCredentials(_ viewAppeared: Bool, reload: Bool = false) {
        let alert = UIAlertController(title: "Credenciales uc 🔑", message: "", preferredStyle: .alert)
        // alert.addAction(AlertAction.cancelAction())
        alert.addAction(AlertAction.alertAction("Log in") {
            let username = alert.textFields?[0].text ?? ""
            let password = alert.textFields?[1].text ?? ""
            Settings.instance.configure(username, password: password)
            self.login(viewAppeared, reload: reload)
            })
        alert.addTextField() {
            $0.placeholder = "Usuario sin @uc"
            $0.text = Settings.instance.username
        }
        alert.addTextField() {
            $0.placeholder = "Contraseña"
            $0.isSecureTextEntry = true
            $0.text = Settings.instance.password
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(_ title: String = "Error", message: String, retry: (() -> Void)? = nil, ok: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(AlertAction.okAction({ _ in ok?() }))
        alert.addAction(AlertAction.retryAction(retry))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let model = model else { return }
        model.prepareForSegue(segue, sender: sender as AnyObject?)
    }
    
}

// MARK: - SidingViewModelDelegate conform
extension SidingViewController: SidingViewModelDelegate {
    
    func loadedSiding(_ model: SidingViewModel, result: LoginResult) {
        dismissLoadingHUD()
        isLogin = false
        switch result {
        case .success:
            model.loadSiding()
        case .error(let reason):
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sidingTable.deselectRow(at: indexPath, animated: true)
        guard let model = model else { return }
        let course = model.courses[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: R.segue.sidingViewController.showCourse, sender: course)
    }
}

// MARK: - UITableViewDataSource conform
extension SidingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model, let section = TableSection(rawValue: section) else { return 0 }
        switch section {
        case .courses:
            return model.courses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model, let section = TableSection(rawValue: (indexPath as NSIndexPath).section) else { return UITableViewCell() }
        switch section {
        case .courses:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.courseCell.identifier) as! CourseCell
            cell.config(model.courses[indexPath.row])
            return cell
        }
    }
}
