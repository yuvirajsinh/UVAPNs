//
//  UVAPNsApp.swift
//  UVAPNs
//
//  Created by Yuvrajsinh Jadeja on 29/06/22.
//

import SwiftUI

@main
struct UVAPNsApp: App {
    @State private var showHelp: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
//        .commands {
//            CommandGroup(replacing: .newItem, addition: {})
//            CommandGroup(replacing: .help, addition: {
//                Button("Easy APNS Help") {
//                    showHelp = true
//                }
//            })
//        }
    }
}
