//
//  NotificationSender.swift
//  Easy APNS
//
//  Created by Yuvrajsinh Jadeja on 04/07/21.
//

import Foundation
import SwiftJWT

typealias ResultHandler = (Result<String, APNSError>) -> Void

class NotificationSender {
    let jwtKey = "kToken"
    let refreshDuration = TimeInterval(25 * 60) // 25 min
    
    var file: File!
    var header: Header!
    var payload: PayloadBody!
    
    func sendNotification(file: File, header: Header, payload: PayloadBody, handler: @escaping ResultHandler) {
        // Compare previous and current file, if not same set old token to nil
        if self.file != file {
            saveNewJWT(newSignedJWT: nil)
        }
        self.file = file
        self.header = header
        self.payload = payload
        
        do {
            // Get authToken/jwtToken
            let authToken = try getToken()
            print("Auth token: \(String(describing: authToken))")
            
            // Set token as authorization header
            self.header.authorization = "bearer " + authToken
            
            // Create json from header
            let headerData = try JSONEncoder().encode(self.header)
            let headerJson = try JSONSerialization.jsonObject(with: headerData, options: .allowFragments) as! [String: String]
            
            // Create payload
            guard let payloadData = self.payload.payload.data(using: .utf8),
                  let _ = try JSONSerialization.jsonObject(with: payloadData, options: .allowFragments) as? [String: Any] else {
                return
            }
            
            // Send request
            let hostUrl = self.payload.environment.url.appendingPathComponent(self.payload.deviceToken)
            self.sendRequest(to: hostUrl, headers: headerJson.filter({ !$0.value.isEmpty }), body: payloadData, handler: handler)
        } catch  {
            print(error)
        }
    }
}

private extension  NotificationSender {
    func getOldJWT() -> String? {
        return UserDefaults.standard.string(forKey: jwtKey)
    }
    
    func saveNewJWT(newSignedJWT: String?) {
        UserDefaults.standard.setValue(newSignedJWT, forKey: jwtKey)
    }
    
    func getToken() throws -> String {
        if let signedJWT = getOldJWT() {
            do {
                let newJWT = try JWT<MyClaims>(jwtString: signedJWT)
                if let expDate = newJWT.claims.exp, expDate > Date() {
                    return signedJWT
                }
            } catch {
                throw error
            }
        }
        do {
            let newJWT = try createJWT()
            saveNewJWT(newSignedJWT: newJWT)
            return newJWT
        } catch {
            throw error
        }
        
        /// Use following verification method if you have public key
        // Create verifier
        /*let jwtDecoder = JWTDecoder(jwtVerifier: jwtVerifier)
        let jwt = try jwtDecoder.decode(JWT<MyClaims>.self, fromString: signedJWT)
        
        guard let publicKey = getPublicKey() else { return nil }
        let jwtVerifier = JWTVerifier.es256(publicKey: publicKey)
        // Verify
        do {
            let jwtObj = try JWT<MyClaims>(jwtString: signedJWT, verifier: jwtVerifier)
            let valid = jwtObj.validateClaims()
            if valid == .success {
                return signedJWT
            }
        } catch {
            print(error)
        }*/
    }
    
    func getPrivateKey() throws -> Data? {
        guard let url = file.fileUrl else {
            #if DEBUG
            print("p8 File URL not found. Please make sure you provide proper file")
            #endif
            return nil
        }

        do {
            let privateKey: Data = try Data(contentsOf: url, options: .alwaysMapped)
            return privateKey
        } catch  {
            throw error
        }
    }
    
    private func createJWT() throws -> String {
        // Create headers
        let myHeader = SwiftJWT.Header(kid: file.keyId)
        // Create Claims
        let myClaims = MyClaims(iss: file.teamId, iat: Date(timeIntervalSinceNow: -1), exp: Date(timeIntervalSinceNow: refreshDuration))
        
        // Create JWT
        var myJWT = JWT(header: myHeader, claims: myClaims)
        
        // Get private key
        if let privateKey = try? getPrivateKey() {
            do {
                // Create JWTSigner
                let jwtSigner = JWTSigner.es256(privateKey: privateKey)
                
                // Sign JWT
                let signedJWT = try myJWT.sign(using: jwtSigner)
                return signedJWT
            } catch {
                throw error
            }
        }
        else {
            throw NotificationError.privateKeyMissing
        }
    }
    
    private func sendRequest(to url: URL, headers: [String: String], body: Data, handler: @escaping ResultHandler) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body
        headers.forEach({ urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) })

        #if DEBUG
        print("[Request] " + urlRequest.cURL(pretty: true))
        #endif
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                #if DEBUG
                print(error)
                #endif
                handler(.failure(.unknown))
            }
            else if let response = response as? HTTPURLResponse {
                #if DEBUG
                print(response)
                #endif
                
                if response.statusCode == 200 {
                    let apnsId = (response.allHeaderFields["apns-id"] as? String) ?? "apns-id Not found"
                    handler(.success(apnsId))
                }
                else if let data = data {
                    #if DEBUG
                    print("[Response data]: \(String(describing: String(data: data, encoding: .utf8)))")
                    #endif
                    
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as? [String: Any],
                       let reason = json["reason"] as? String, let apnsError = APNSError(rawValue: reason) {
                        handler(.failure(apnsError))
                    }
                    else {
                        handler(.failure(.unknown))
                    }
                }
                else {
                    handler(.failure(.unknown))
                }
            }
        }
        .resume()
    }
}

struct MyClaims: Claims {
    let iss: String
    var iat: Date?
    var exp: Date?
}

enum NotificationError: Error {
    case privateKeyMissing
    case jwtTokenCreationFailed
}
