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
    
    /// image for button auth
    let imageToDoist = readResizeImage(named: "ToDoist_mainicon", 128.0, 128.0)
    
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
            }
            Spacer()
            HStack {
                Text("Groylov Aleksey ©")
            }
        }
        .padding(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView()
    }
}


