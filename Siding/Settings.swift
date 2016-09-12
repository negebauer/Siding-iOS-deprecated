//
//  Settings.swift
//  Wifi UC
//
//  Created by Nicolás Gebauer on 04-04-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit
import KeychainAccess

class Settings: NSObject {
    
    // MARK: - Constants

    static let instance = Settings()
    fileprivate let keychain = Keychain(service: "com.negebauer.Siding")
    fileprivate let keyUsername = "username"
    fileprivate let keyPassword = "password"
    fileprivate let keyConfigured = "configured"
    fileprivate let keyReviewVersion = "reviewVersion"
    
    // MARK: - Variables
    
    var username: String {
        get {
            if let username = try? keychain.getString(keyUsername) {
                return username ?? ""
            }
            return ""
        } set {
            let _ = try? keychain.set(newValue ?? "", key: keyUsername)
        }
    }
    
    var password: String {
        get {
            if let password = try? keychain.getString(keyPassword) {
                return password ?? ""
            }
            return ""
        } set {
            let _ = try? keychain.set(newValue ?? "", key: keyPassword)
        }
    }
    
    var reviewVersion: String {
        get {
            if let reviewVersion = try? keychain.getString(keyReviewVersion) {
                return reviewVersion ?? ""
            }
            return ""
        } set {
            let _ = try? keychain.set(newValue ?? "", key: keyReviewVersion)
        }
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: keyConfigured) {
            deleteData()
            userDefaults.set(true, forKey: keyConfigured)
        }
    }
    
    // MARK: - Functions

    func isUserSet() -> Bool {
        return (username != "" && password != "")
    }
    
    func configure(_ username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    func deleteData() {
        username = ""
        password = ""
    }
}
