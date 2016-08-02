//
//  Toast.swift
//  Wifi UC
//
//  Created by Nicolás Gebauer on 13-06-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import Toast_Swift

/// Wrapper for making toasts
struct Toast {
    
    static func configure() {
        ToastManager.shared.tapToDismissEnabled = false
        ToastManager.shared.queueEnabled = true
    }
}

extension UIViewController {
    
    func toastLoading() {
        view?.makeToastActivity(.Center)
    }
    
    func toastLoadingFinished() {
        view?.hideToastActivity()
    }
}