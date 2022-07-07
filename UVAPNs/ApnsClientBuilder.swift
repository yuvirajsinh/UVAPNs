//
//  ApnsClientBuilder.swift
//  Easy APNS
//
//  Created by Yuvrajsinh Jadeja on 08/07/21.
//

import Foundation

struct ApnsClientBuilder {
    enum ApnsBuilderError: Error {
        case apnsServerNotFound(_ message: String)
        case signingDetailMissing(_ message: String)
    }
    
    var apnsHost: String = ""
    var signingKeyUrl: URL?
    var teamId: String = ""
    var keyId: String = ""
    
    mutating func setApnsServer(_ host: APNSEnvironment) -> Self {
        apnsHost = host.rawValue
        
        return self
    }
    
    mutating func setSigningKey(_ keyUrl: URL, teamId: String, keyId: String) -> Self {
        self.signingKeyUrl = keyUrl
        self.teamId = teamId
        self.keyId = keyId
        
        return self
    }
    
    func build() throws -> ApnsClient {
        if apnsHost.isEmpty {
            throw ApnsBuilderError.apnsServerNotFound("APNS server not found")
        }
        if signingKeyUrl == nil || teamId.isEmpty || keyId.isEmpty {
            throw ApnsBuilderError.signingDetailMissing("Signing key or Team id or keyId is missing")
        }
        return ApnsClient(apnsHost: apnsHost, signingKeyUrl: signingKeyUrl!, teamId: teamId, keyId: keyId)
    }
}

struct ApnsClient {
    var apnsHost: String
    var signingKeyUrl: URL
    var teamId: String
    var keyId: String
}
