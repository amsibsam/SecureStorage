//
//  AESMock.swift
//  SecureStorage_Tests
//
//  Created by Rahardyan Bisma on 09/02/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

@testable import SecureStorage
import Foundation

class KeychainServiceMock: KeychainService {
    var isSetStringCalled = false
    var isSetDataCalled = false
    var isGetStringCalled = false
    var isGetDataCalled = false
    var isRemoveValueCalled = false
    var isRemoveAllCalled = false

    func set(_: String, forKey _: String) throws {
        isSetStringCalled = true
    }

    func set(_: Data, forKey _: String) throws {
        isSetDataCalled = true
    }

    func getString(forKey _: String) throws -> String? {
        isGetStringCalled = true
        return ""
    }

    func getData(forKey _: String) throws -> Data? {
        isGetDataCalled = true
        return Data()
    }

    func removeValue(forKey _: String) throws {
        isRemoveValueCalled = true
    }

    func removeAllValue() throws {
        isRemoveAllCalled = true
    }
}
