//
//  AES.swift
//  SecureStorage
//
//  Created by Rahardyan Bisma on 09/02/22.
//

import CommonCrypto
import Foundation

public protocol Cryptable {
    func encrypt(_ data: Data) throws -> Data
    func encrypt(_ string: String) throws -> Data
    func decrypt(_ data: Data) throws -> String
    func decrypt(_ data: Data) throws -> Data
}

public struct AES {
    private let key: Data
    private let ivSize: Int = kCCBlockSizeAES128
    private let options = CCOptions(kCCOptionPKCS7Padding)

    init(keyData: Data) {
        key = keyData
    }
}

extension AES {
    enum Error: Swift.Error {
        case invalidKeySize
        case generateRandomIVFailed
        case encryptionFailed
        case decryptionFailed
        case dataToStringFailed
    }

    func generateRandomIV(for data: inout Data) throws {
        try data.withUnsafeMutableBytes { dataBytes in

            guard let dataBytesBaseAddress = dataBytes.baseAddress else {
                throw Error.generateRandomIVFailed
            }

            let status: Int32 = SecRandomCopyBytes(
                kSecRandomDefault,
                kCCAlgorithmAES128,
                dataBytesBaseAddress
            )

            guard status == 0 else {
                throw Error.generateRandomIVFailed
            }
        }
    }
}

extension AES: Cryptable {
    public func encrypt(_ data: Data) throws -> Data {
        let bufferSize: Int = ivSize + data.count + kCCKeySizeAES128
        var buffer = Data(count: bufferSize)
        try generateRandomIV(for: &buffer)

        var numberBytesEncrypted: Int = 0

        do {
            try key.withUnsafeBytes { keyBytes in
                try data.withUnsafeBytes { dataToEncryptBytes in
                    try buffer.withUnsafeMutableBytes { bufferBytes in

                        guard let keyBytesBaseAddress = keyBytes.baseAddress,
                              let dataToEncryptBytesBaseAddress = dataToEncryptBytes.baseAddress,
                              let bufferBytesBaseAddress = bufferBytes.baseAddress
                        else {
                            throw Error.encryptionFailed
                        }

                        let cryptStatus: CCCryptorStatus = CCCrypt( // Stateless, one-shot encrypt operation
                            CCOperation(kCCEncrypt), // op: CCOperation
                            CCAlgorithm(kCCAlgorithmAES), // alg: CCAlgorithm
                            options, // options: CCOptions
                            keyBytesBaseAddress, // key: the "password"
                            key.count, // keyLength: the "password" size
                            bufferBytesBaseAddress, // iv: Initialization Vector
                            dataToEncryptBytesBaseAddress, // dataIn: Data to encrypt bytes
                            dataToEncryptBytes.count, // dataInLength: Data to encrypt size
                            bufferBytesBaseAddress + ivSize, // dataOut: encrypted Data buffer
                            bufferSize, // dataOutAvailable: encrypted Data buffer size
                            &numberBytesEncrypted // dataOutMoved: the number of bytes written
                        )

                        guard cryptStatus == CCCryptorStatus(kCCSuccess) else {
                            throw Error.encryptionFailed
                        }
                    }
                }
            }

        } catch {
            throw Error.encryptionFailed
        }

        let encryptedData: Data = buffer[..<(numberBytesEncrypted + ivSize)]
        return encryptedData
    }
    
    public func encrypt(_ string: String) throws -> Data {
        let dataToEncrypt = Data(string.utf8)

        return try encrypt(dataToEncrypt)
    }

    public func decrypt(_ data: Data) throws -> Data {
        let bufferSize: Int = data.count - ivSize
        var buffer = Data(count: bufferSize)

        var numberBytesDecrypted: Int = 0

        do {
            try key.withUnsafeBytes { keyBytes in
                try data.withUnsafeBytes { dataToDecryptBytes in
                    try buffer.withUnsafeMutableBytes { bufferBytes in

                        guard let keyBytesBaseAddress = keyBytes.baseAddress,
                              let dataToDecryptBytesBaseAddress = dataToDecryptBytes.baseAddress,
                              let bufferBytesBaseAddress = bufferBytes.baseAddress
                        else {
                            throw Error.encryptionFailed
                        }

                        let cryptStatus: CCCryptorStatus = CCCrypt( // Stateless, one-shot encrypt operation
                            CCOperation(kCCDecrypt), // op: CCOperation
                            CCAlgorithm(kCCAlgorithmAES128), // alg: CCAlgorithm
                            options, // options: CCOptions
                            keyBytesBaseAddress, // key: the "password"
                            key.count, // keyLength: the "password" size
                            dataToDecryptBytesBaseAddress, // iv: Initialization Vector
                            dataToDecryptBytesBaseAddress + ivSize, // dataIn: Data to decrypt bytes
                            bufferSize, // dataInLength: Data to decrypt size
                            bufferBytesBaseAddress, // dataOut: decrypted Data buffer
                            bufferSize, // dataOutAvailable: decrypted Data buffer size
                            &numberBytesDecrypted // dataOutMoved: the number of bytes written
                        )

                        guard cryptStatus == CCCryptorStatus(kCCSuccess) else {
                            throw Error.decryptionFailed
                        }
                    }
                }
            }
        } catch {
            throw Error.encryptionFailed
        }

        let decryptedData: Data = buffer[..<numberBytesDecrypted]
        return decryptedData
    }
    
    public func decrypt(_ data: Data) throws -> String {
        guard let decryptedData: Data = try? decrypt(data),
                let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            throw Error.dataToStringFailed
        }

        return decryptedString
    }
}