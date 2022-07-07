//
//  Priority.swift
//  Easy APNS
//
//  Created by Yuvrajsinh Jadeja on 03/07/21.
//

import Foundation

enum Priority: String, Identifiable , CaseIterable, Encodable {
    case immediately = "10"
    case normal = "5"
    
    var id: String { self.rawValue }
    
    enum CodingKeys: String, CodingKey {
        case immediately
        case normal
    }
    
    var value: Int {
        switch self {
        case .immediately:
            return 10
        case .normal:
            return 5
        }
    }
    
}
