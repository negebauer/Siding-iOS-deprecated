//
//  ProgressHUDContainer.swift
//  Wifi UC
//
//  Created by Nicolás Gebauer on 13-06-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import MBProgressHUD

protocol ProgressHUDContainer: class {
    
    var hud: MBProgressHUD? { get set }
    
    func showLoadingHUD(_ text: String)
    func dismissLoadingHUD()
}

extension ProgressHUDContainer where Self: UIViewController {
    
    func showLoadingHUD(_ text: String = "Cargando") {
        mainQueue(({
            self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.hud?.mode = MBProgressHUDMode.indeterminate
            self.hud?.label.text = text
        }))
    }
    
    func dismissLoadingHUD() {
        mainQueue({
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func showProgressLoadingHUD(_ text: String = "Cargando", progress: Float) {
        mainQueue(({
            self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.hud?.mode = MBProgressHUDMode.determinate
            self.hud?.label.text = text
        }))
    }
}
