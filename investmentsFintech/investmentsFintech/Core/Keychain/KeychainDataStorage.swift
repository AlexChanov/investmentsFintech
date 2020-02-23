//
//  KeychainDataStorage.swift
//  InvestmentsFintech
//
//  Created by Vitaliy Pyatnikov on 23.02.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

import Foundation

// MARK: - KeychainDataStorageWorker

protocol KeychainDataStorageWorker {
    /// Saves data to Keychain
    /// - Parameters:
    ///   - data: Data to be saved in Keychain
    ///   - key: The key by which data will be saved
    func save(encodedData data: Data, forKey key: String)
    /// Retrieves data from Keychain
    func getData(forKey key: String) -> Data?
    /// Removes specific data from Keychain
    /// - Parameter key: The key by which data will be removed
    func remove(forKey key: String)
    /// Removes all data from Keychain
    /// Potentially dangerous function. It can delete all keychain data.
    func removeAll()
}

// MARK: - KeychainDataStorage

final class KeychainDataStorage {

    // MARK: - Private

    private let currentConfiguration: KeychainConfiguration = .standart
}

// MARK: - KeychainDataStorageWorker

extension KeychainDataStorage: KeychainDataStorageWorker {
    func save(encodedData data: Data, forKey key: String) {
        var item = KeychainItem.retrieve(forKey: key, using: currentConfiguration)
        item.data = data
    }
    func getData(forKey key: String) -> Data? {
        let item = KeychainItem.retrieve(forKey: key, using: currentConfiguration)
        return item.data
    }
    func remove(forKey key: String) {
        var item = KeychainItem.retrieve(forKey: key, using: currentConfiguration)
        item.data = nil
    }
    func removeAll() {
        KeychainItem.resetKeychain()
    }
}
