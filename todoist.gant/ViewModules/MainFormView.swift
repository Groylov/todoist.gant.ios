//
//  MainFormView.swift
//  todoist.gant
//
//  Created by Aleksey Groylov on 05.04.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//

import SwiftUI

struct itemSetting: View {
    
    var itemName: String
    var itemDestination: AnyView
    var body: some View {
            NavigationLink(destination: self.itemDestination) {
                Text(itemName)
                Image(systemName: "minus.square.fill")
        }
        
    }
}

struct itemSettingsView: View {
    var body: some View {
        Text("24242424424")
    }
}

struct SettingFormView: View {
    
    var body: some View {
        NavigationView {
            Text("SwiftUI")
                .navigationBarItems(trailing:
                    Button("Help") {
                        print("Help tapped!")
                    }
                )
        }
    }

    var bodys: some View {
        NavigationView {
            Text("Hello World!")
            }.navigationBarItems(leading:
                HStack {
                    Button(action: {}) {
                        Image(systemName: "minus.square.fill")
                            .font(.largeTitle)
                    }.foregroundColor(.pink)
                }, trailing:
                HStack {
                    Button(action: {}) {
                        Image(systemName: "plus.square.fill")
                            .font(.largeTitle)
                    }.foregroundColor(.blue)
            })
            .navigationBarTitle(Text("Names"))
    }
}



struct MainFormView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}





#if DEBUG
struct MainFormView_Previews: PreviewProvider {
    static var previews: some View {
        SettingFormView()
    }
}
#endif
