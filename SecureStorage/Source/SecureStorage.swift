//
//  SecureStorage.swift
//  SecureStorage
//
//  Created by Rahardyan Bisma on 15/01/21.
//

import Foundation

public class SecureStorage {
    
    private let keychainService: KeychainService
    private let cryptableFactory: CryptableFactory
    
    public init(keychainService: KeychainService = KeychainServiceImpl(), cryptableFactory: CryptableFactory = CryptableFactoryImpl()) {
        self.keychainService = keychainService
        self.cryptableFactory = cryptableFactory
    }
    
    public func set(_ stringValue: String, forKey key: String) {
        guard let encryptedValue = try? cryptableFactory.createAES()?.encrypt(stringValue) else {
            return
        }
        
        try? keychainService.set(encryptedValue, forKey: key)
    }
    
    public func set(_ dataValue: Data, forKey key: String) {
        guard let encryptedValue = try? cryptableFactory.createAES()?.encrypt(dataValue) else {
            return
        }
        
        try? keychainService.set(encryptedValue, forKey: key)
    }

    public func getString(forKey key: String) -> String? {
        guard let encryptedValue = try? keychainService.getData(forKey: key),
              let decryptedValue: String = try? cryptableFactory.createAES()?.decrypt(encryptedValue)
        else {
            return nil
        }
        
        return decryptedValue
    }
    
    public func getData(forKey key: String) -> Data? {
        guard let encryptedValue = try? keychainService.getData(forKey: key),
              let decryptedValue: Data = try? cryptableFactory.createAES()?.decrypt(encryptedValue)
        else {
            return nil
        }
        
        return decryptedValue
    }

    public func removeValue(forKey key: String) {
        try? keychainService.removeValue(forKey: key)
    }
    
    public func removeAllValue() {
        try? keychainService.removeAllValue()
    }
}
