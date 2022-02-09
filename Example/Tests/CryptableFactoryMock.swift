//
//  CryptableFactoryMock.swift
//  SecureStorage_Tests
//
//  Created by Rahardyan Bisma on 09/02/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

@testable import SecureStorage
import Foundation

class CryptableFactoryMock: CryptableFactory {
    var aesMock = AESMock()
    func createAES() -> Cryptable? {
        return aesMock
    }
}

