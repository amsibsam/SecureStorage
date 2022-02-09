//
//  ViewController.swift
//  SecureStorage
//
//  Created by amsibsam on 02/09/2022.
//  Copyright (c) 2022 amsibsam. All rights reserved.
//

import UIKit
import SecureStorage

class ViewController: UIViewController {
    @IBOutlet weak var tfKey: UITextField!
    
    @IBOutlet weak var tfValue: UITextField!
    
    @IBOutlet weak var lblResult: UILabel!
    
    @IBOutlet weak var lblEncryptedValue: UILabel!
    private let secureStorage = SecureStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func set(_ sender: Any) {
        guard let key = tfKey.text, !key.isEmpty,
                let value = tfValue.text else {
            return
        }
        
        secureStorage.set(value, forKey: key)
        
        let encryptedData = try? KeychainServiceImpl().getData(forKey: key)
        let encryptedDataString = String(decoding: encryptedData!, as: UTF8.self)
        lblResult.text = "\(encryptedDataString)"
    }
    
    @IBAction func get(_ sender: Any) {
        guard let key = tfKey.text, !key.isEmpty else {
            return
        }
        
        lblResult.text = secureStorage.getString(forKey: key)
    }
    
}

struct Product: Codable {
    let name: String
    let price: Double
}

