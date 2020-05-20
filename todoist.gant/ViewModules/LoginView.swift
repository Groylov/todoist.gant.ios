//
//  LoginView.swift
//  todoist.gant
//
//  Created by Aleksey Groylov on 31.03.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//

import SwiftUI

/// Application authorization form in the service ToDoist
struct LoginFormView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    /// image for button auth
    let imageToDoist = readResizeImage(named: "ToDoist_mainicon", 128.0, 128.0)
    
    /// function event tap for auth in service ToDoist
    func tapLoginToDoist() {
        #if DEBUG
        let userSettings = UserSettings.shared
        userSettings.userToken = "c7f0ff9c3c34b7e074dc6830f481e9b6f90fe2fb"
        userSettings.saveSettings()
        
        /*
         curl https://api.todoist.com/sync/v8/sync \
         -d token=c7f0ff9c3c34b7e074dc6830f481e9b6f90fe2fb \
         -d sync_token='*' \
         -d resource_types='["user_settings"]'
         
         */
        #endif
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if imageToDoist != nil {
                    VStack {
                        Text("Auth in ToDoist service")
                            .fontWeight(.bold)
                        Image(uiImage: imageToDoist!)
                    }
                } else {
                    Text("Auth in ToDoist")
                }
            }.onTapGesture {
                self.tapLoginToDoist()
            }
            Spacer()
            HStack {
                Text("Groylov Aleksey ©")
            }
        }
        .padding(.all)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView()
    }
}
#endif


