//
//  PushType.swift
//  Easy APNS
//
//  Created by Yuvrajsinh Jadeja on 03/07/21.
//

import Foundation

enum PushType: String, Identifiable, CaseIterable, Encodable {
    case alert
    case background
    case voip
    case complication
    case fileprovider
    case mdm
    
    var id: String { self.rawValue }
    
    enum CodingKeys: String, CodingKey {
        case alert
        case background
        case voip
        case complication
        case fileprovider
        case mdm
    }
}
