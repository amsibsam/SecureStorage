//
//  KeychainServiceImpl.swift
//  SecureStorage
//
//  Created by Rahardyan Bisma on 09/02/22.
//

import Foundation
import Security
import UIKit

public final class KeychainServiceImpl: KeychainService {
    let defaultServiceName = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
    
    public init() {}

    public func set(_ stringValue: String, forKey key: String) throws {
        guard let encodedPassword = stringValue.data(using: .utf8) else {
            throw SecureStoreError.string2DataConversionError
        }

        var query: [String: Any] = [
            String(kSecAttrService): defaultServiceName as Any,
            String(kSecClass): kSecClassGenericPassword,
        ]
        query[String(kSecAttrAccount)] = key

        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = encodedPassword

            status = SecItemUpdate(query as CFDictionary,
                                   attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw error(from: status)
            }
        case errSecItemNotFound:
            query[String(kSecValueData)] = encodedPassword

            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }

    public func set(_ data: Data, forKey key: String) throws {
        var query: [String: Any] = [
            String(kSecAttrService): defaultServiceName as Any,
            String(kSecClass): kSecClassGenericPassword,
        ]
        query[String(kSecAttrAccount)] = key

        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = data

            status = SecItemUpdate(query as CFDictionary,
                                   attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw error(from: status)
            }
        case errSecItemNotFound:
            query[String(kSecValueData)] = data

            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }

    public func getString(forKey key: String) throws -> String? {
        guard let data = try getData(forKey: key) else {
            return nil
        }

        let string = String(decoding: data, as: UTF8.self)
        return string
    }

    public func getData(forKey key: String) throws -> Data? {
        var query: [String: Any] = [
            String(kSecAttrService): defaultServiceName as Any,
            String(kSecClass): kSecClassGenericPassword,
        ]
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = key

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let passwordData = queriedItem[String(kSecValueData)] as? Data
            else {
                throw SecureStoreError.unhandledError(message: "")
            }
            return passwordData
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }

    public func removeAllValue() throws {
        let query: [String: Any] = [
            String(kSecAttrService): defaultServiceName as Any,
            String(kSecClass): kSecClassGenericPassword,
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    public func removeValue(forKey key: String) throws {
        var query: [String: Any] = [
            String(kSecAttrService): defaultServiceName as Any,
            String(kSecClass): kSecClassGenericPassword,
        ]
        query[String(kSecAttrAccount)] = key

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    private func error(from status: OSStatus) -> SecureStoreError {
        var message = "keychain error"
        if #available(iOS 11.3, *) {
            message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        }

        return SecureStoreError.unhandledError(message: message)
    }
}

public enum SecureStoreError: Error {
    case string2DataConversionError
    case data2StringConversionError
    case unhandledError(message: String)
}

extension SecureStoreError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .string2DataConversionError:
            return NSLocalizedString("String to Data conversion error", comment: "")
        case .data2StringConversionError:
            return NSLocalizedString("Data to String conversion error", comment: "")
        case let .unhandledError(message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
