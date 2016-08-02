//
//  AlertAction.swift
//  Wifi UC
//
//  Created by Nicolás Gebauer on 16-04-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit

struct AlertAction {
    
    static func alertAction(title: String, style: UIAlertActionStyle = .Default, handler: ((action: UIAlertAction) -> Void)? = nil, callback: (() -> Void)? = nil) -> UIAlertAction {
        let alertAction = UIAlertAction(title: title, style: style, handler: realHandler(handler, callback: callback))
        return alertAction
    }
    
    static func retryAction(handler: (() -> Void)? = nil) -> UIAlertAction {
        let retryAction = alertAction("Reintentar", handler: { _ in handler?() })
        return retryAction
    }

    static func okAction(handler: ((action: UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let okAction = alertAction("Ok", handler: handler)
        return okAction
    }

    static func cancelAction(handler: ((action: UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let cancelAction = alertAction("Cancelar", style: .Cancel, handler: handler)
        return cancelAction
    }
    
    static func destructiveAction(message: String, handler: ((action: UIAlertAction) -> Void)? = nil,
                                  callback: (() -> Void)? = nil) -> UIAlertAction {
        let destructiveAction = alertAction(message, style: .Destructive, handler: realHandler(handler, callback: callback))
        return destructiveAction
    }

    static private func realHandler(handler: ((action: UIAlertAction) -> Void)? = nil,
                             callback: (() -> Void)? = nil) -> ((action: UIAlertAction) -> Void) {
        let realHandler: ((action: UIAlertAction) -> Void) = {
            handler?(action: $0)
            callback?()
        }
        return realHandler
    }
    
}