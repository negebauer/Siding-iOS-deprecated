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
    
    func showLoadingHUD(text: String)
    func dismissLoadingHUD()
}

extension ProgressHUDContainer where Self: UIViewController {
    
    func showLoadingHUD(text: String = "Cargando") {
        mainQueue(({
            self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.hud?.mode = MBProgressHUDMode.Indeterminate
            self.hud?.label.text = text
        }))
    }
    
    func dismissLoadingHUD() {
        mainQueue({
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func showProgressLoadingHUD(text: String = "Cargando", progress: Float) {
        mainQueue(({
            self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.hud?.mode = MBProgressHUDMode.Determinate
            self.hud?.label.text = text
        }))
    }
}