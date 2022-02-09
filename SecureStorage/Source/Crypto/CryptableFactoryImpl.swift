//
//  CryptableFactoryImpl.swift
//  SecureStorage
//
//  Created by Rahardyan Bisma on 09/02/22.
//

import Foundation

public class CryptableFactoryImpl: CryptableFactory {
    
    public init() {}
    
    public func createAES() -> Cryptable? {
        guard let key = getOrCreateKey() else {
            return nil
        }

        return AES(keyData: key)
    }

    func getOrCreateKey() -> Data? {
        if let existingKey = try? KeychainServiceImpl().getData(forKey: "AES_KEY") {
            return existingKey
        }

        let key = createKey()

        try? KeychainServiceImpl().set(key, forKey: "AES_KEY")
        return key
    }

    func createKey() -> Data {
        var keyData = Data(count: 32)
        _ = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
        }

        return keyData
    }
}
