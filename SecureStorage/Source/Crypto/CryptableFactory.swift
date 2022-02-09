//
//  CryptableFactory.swift
//  SecureStorage
//
//  Created by Rahardyan Bisma on 09/02/22.
//

import Foundation

public protocol CryptableFactory {
    func createAES() -> Cryptable?
}
