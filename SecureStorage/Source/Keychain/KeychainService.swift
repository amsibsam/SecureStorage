//
//  KeychainService.swift
//  SecureStorage
//
//  Created by Rahardyan Bisma on 09/02/22.
//

import Foundation

public protocol KeychainService {
    func set(_ stringValue: String, forKey key: String) throws
    func set(_ dataValue: Data, forKey key: String) throws
    func getString(forKey key: String) throws -> String?
    func getData(forKey key: String) throws -> Data?
    func removeValue(forKey key: String) throws
    func removeAllValue() throws
}
