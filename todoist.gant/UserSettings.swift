//
//  UserSettings.swift
//  todoist.gant
//
//  Created by Aleksey Groylov on 05.04.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//

import Foundation

class UserSettings {
    static var shared = UserSettings()
    
    var userToken: String? 
    
    private init() {}
    
    /// Function load user settings
    func loadSettings() {
        userToken = UserDefaults.standard.string(forKey: "UserToken")
    }
    
    /// Function save all user settings
    func saveSettings() {
        UserDefaults.standard.set(userToken, forKey: "UserToken")
    }
}
