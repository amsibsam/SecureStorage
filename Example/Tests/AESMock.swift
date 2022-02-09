//
//  KeychainServiceMock.swift
//  SecureStorage_Tests
//
//  Created by Rahardyan Bisma on 09/02/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

@testable import SecureStorage
import Foundation

class AESMock: Cryptable {
    
    var isEncryptCalled = false
    var isDecryptCalled = false
    var isEncryptDataCalled = false
    var isDecryptDataCalled = false
    func encrypt(_: String) throws -> Data {
        isEncryptCalled = true
        return Data()
    }

    func decrypt(_: Data) throws -> String {
        isDecryptCalled = true
        return ""
    }
    
    func encrypt(_: Data) throws -> Data {
        isEncryptDataCalled = true
        return Data()
    }
    
    func decrypt(_: Data) throws -> Data {
        isDecryptDataCalled = true
        return Data()
    }
}
