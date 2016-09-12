//
//  AlertAction.swift
//  Wifi UC
//
//  Created by Nicolás Gebauer on 16-04-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit

struct AlertAction {
    
    static func alertAction(_ title: String, style: UIAlertActionStyle = .default, handler: ((_ action: UIAlertAction) -> Void)? = nil, callback: (() -> Void)? = nil) -> UIAlertAction {
        let alertAction = UIAlertAction(title: title, style: style, handler: realHandler(handler, callback: callback))
        return alertAction
    }
    
    static func retryAction(_ handler: (() -> Void)? = nil) -> UIAlertAction {
        let retryAction = alertAction("Reintentar", handler: { _ in handler?() })
        return retryAction
    }

    static func okAction(_ handler: ((_ action: UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let okAction = alertAction("Ok", handler: handler)
        return okAction
    }

    static func cancelAction(_ handler: ((_ action: UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let cancelAction = alertAction("Cancelar", style: .cancel, handler: handler)
        return cancelAction
    }
    
    static func destructiveAction(_ message: String, handler: ((_ action: UIAlertAction) -> Void)? = nil,
                                  callback: (() -> Void)? = nil) -> UIAlertAction {
        let destructiveAction = alertAction(message, style: .destructive, handler: realHandler(handler, callback: callback))
        return destructiveAction
    }

    static fileprivate func realHandler(_ handler: ((_ action: UIAlertAction) -> Void)? = nil,
                             callback: (() -> Void)? = nil) -> ((_ action: UIAlertAction) -> Void) {
        let realHandler: ((_ action: UIAlertAction) -> Void) = {
            handler?($0)
            callback?()
        }
        return realHandler
    }
    
}
