//
//  Header.swift
//  Easy APNS
//
//  Created by Yuvrajsinh Jadeja on 03/07/21.
//

import Foundation

struct Header: Encodable {
    var authorization: String
    var pushType: PushType
    var priority: Priority
    var collapseId: String
    var notificationId: String
    var expiration: String
    var apnsTopic: String
    
    enum CodingKeys: String, CodingKey {
        case authorization
        case pushType = "apns-push-type"
        case priority = "apns-priority"
        case collapseId = "apns-collapse-id"
        case notificationId = "apns-id"
        case expiration = "apns-expiration"
        case apnsTopic = "apns-topic"
    }
    
    var isValid: Bool {
        return !apnsTopic.isEmpty
    }
}

struct File: Equatable {
    var fileUrl: URL?
//    var filename: String
    var teamId: String
    var keyId: String
    
    var isValid: Bool {
        return fileUrl != nil && !teamId.isEmpty && !keyId.isEmpty
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.fileUrl?.absoluteString == rhs.fileUrl?.absoluteString && lhs.teamId == rhs.teamId && lhs.keyId == rhs.keyId
    }
}

struct PayloadBody {
    var deviceToken: String
    var payload: String
    var environment: APNSEnvironment
    
    var isValid: Bool {
        return !deviceToken.isEmpty && !payload.isEmpty
    }
}
