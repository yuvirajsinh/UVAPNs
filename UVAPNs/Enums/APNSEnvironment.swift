//
//  APNSEnvironment.swift
//  Easy APNS
//
//  Created by Yuvrajsinh Jadeja on 03/07/21.
//

import Foundation

enum APNSEnvironment: String, Identifiable, CaseIterable {
    case sandbox = "Sandbox"
    case production = "Production"
    
    var id: String { self.rawValue }
    
    var url: URL {
        switch self {
        case .sandbox:
            return URL(string: "https://api.sandbox.push.apple.com:2197/3/device/")!
        case .production:
            return URL(string: "https://api.push.apple.com:443/3/device/")!
        }
    }
}
