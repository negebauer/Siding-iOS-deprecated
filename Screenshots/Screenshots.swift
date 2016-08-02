//
//  Screenshots.swift
//  Screenshots
//
//  Created by Nicolás Gebauer on 01-08-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import XCTest

class Screenshots: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testScreenshots() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        // Ready to take screenshots
        // snapshot("01LoginScreen")
    }
    
}
