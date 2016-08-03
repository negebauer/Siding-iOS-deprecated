//
//  QueueUtilities.swift
//  Wifi UC
//
//  Created by Nicolás Gebauer on 16-04-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import Foundation

/// MainQueue: UI updates must be done here.
func mainQueue(block: () -> Void) {
    dispatch_async(dispatch_get_main_queue(), {
        block()
    })
}