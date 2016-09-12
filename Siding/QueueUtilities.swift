//
//  QueueUtilities.swift
//  Wifi UC
//
//  Created by Nicolás Gebauer on 16-04-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import Foundation

/// MainQueue: UI updates must be done here.
func mainQueue(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: {
        block()
    })
}
