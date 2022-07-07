//
//  APNSError.swift
//  Easy APNS
//
//  Created by Yuvrajsinh Jadeja on 11/07/21.
//

import Foundation

enum APNSError: String, Error {
    case BadCollapseId
    case BadDeviceToken
    case BadExpirationDate
    case BadMessageId
    case BadPriority
    case BadTopic
    case DeviceTokenNotForTopic
    case DuplicateHeaders
    case IdleTimeout
    case InvalidPushType
    case MissingDeviceToken
    case MissingTopic
    case PayloadEmpty
    case TopicDisallowed
    case BadCertificate
    case BadCertificateEnvironment
    case ExpiredProviderToken
    case Forbidden
    case InvalidProviderToken
    case MissingProviderToken
    case BadPath
    case MethodNotAllowed
    case Unregistered
    case PayloadTooLarge
    case TooManyProviderTokenUpdates
    case TooManyRequests
    case InternalServerError
    case ServiceUnavailable
    case Shutdown
    case unknown
    
    var errorDescription: String {
        switch self {
        case .BadCollapseId:
            return "The collapse identifier exceeds the maximum allowed size"
        case .BadDeviceToken:
            return "The specified device token is invalid. Verify that the request contains a valid token and that the token matches the environment"
        case .BadExpirationDate:
            return "The apns-expiration value is invalid"
        case .BadMessageId:
            return "The apns-id value is invalid"
        case .BadPriority:
            return "The apns-priority value is invalid"
        case .BadTopic:
            return "The apns-topic value is invalid"
        case .DeviceTokenNotForTopic:
            return "The device token doesn’t match the specified topic"
        case .DuplicateHeaders:
            return "One or more headers are repeated"
        case .IdleTimeout:
            return "Idle timeout"
        case .InvalidPushType:
            return "The apns-push-type value is invalid"
        case .MissingDeviceToken:
            return "The device token isn’t specified in the request :path. Verify that the :path header contains the device token"
        case .MissingTopic:
            return "The apns-topic header of the request isn’t specified and is required. The apns-topic header is mandatory when the client is connected using a certificate that supports multiple topics"
        case .PayloadEmpty:
            return "The message payload is empty"
        case .TopicDisallowed:
            return "Pushing to this topic is not allowed"
        case .BadCertificate:
            return "The certificate is invalid"
        case .BadCertificateEnvironment:
            return "The client certificate is for the wrong environment"
        case .ExpiredProviderToken:
            return "The provider token is stale and a new token should be generated"
        case .Forbidden:
            return "The specified action is not allowed"
        case .InvalidProviderToken:
            return "The provider token is not valid, or the token signature can't be verified"
        case .MissingProviderToken:
            return "No provider certificate was used to connect to APNs, and the authorization header is missing or no provider token is specified"
        case .BadPath:
            return "The request contained an invalid :path value"
        case .MethodNotAllowed:
            return "The specified :method value isn’t POST"
        case .Unregistered:
            return "The device token is inactive for the specified topic. There is no need to send further pushes to the same device token, unless your application retrieves the same device token"
        case .PayloadTooLarge:
            return "The message payload is too large. For information about the allowed payload size"
        case .TooManyProviderTokenUpdates:
            return "The provider’s authentication token is being updated too often. Update the authentication token no more than once every 20 minutes"
        case .TooManyRequests:
            return "Too many requests were made consecutively to the same device token"
        case .InternalServerError:
            return "An internal server error occurred"
        case .ServiceUnavailable:
            return "The service is unavailable"
        case .Shutdown:
            return "The APNs server is shutting down"
        case .unknown:
            return "Some unknown error"
        }
    }
}
