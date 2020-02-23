//
//  KeychainItem.swift
//  InvestmentsFintech
//
//  Created by Vitaliy Pyatnikov on 23.02.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

import Foundation

// MARK: - KeychainItem

/// Structure that contains all the necessary data to work with the keychain
struct KeychainItem {

    // MARK: - Properties

    /// The corresponding value that represents the service associated with this item.
    /// Used for searching keychain items associated with our serviceName.
    let service: String
    /// Corresponds to the key kSecAttrAccount
    var key: String
    /// The corresponding value is of type CFString and indicates which access group an item is in.
    /// Access groups are used to share keychain items among two or more apps.
    /// For apps to share a keychain item, they must have a common access group.
    let accessGroup: String?
    /// The security keychain level
    let keychainLevel: KeychainLevel
    /// Identifies how the keychain query defines the key generation for the database request
    let keyConstructor: KeyConstructor
    let keychainItemClass: KeychainItemClass

    /// Associated with data that is stored / can be added to the Keychain.
    var data: Data? {
        /* Trying to retrieve data from Keychain.
         Success — returns data associated with KeychainItem.
         Fail — returns nil.
        */
        get {
            return readItem()
        }
        /* Trying to save data to Keychain.
         If the data is not nil:
            If item data already exists — update it, else — create the new one.
            Success — data saved/updated.
            Fail — returns.

         If data is nil:
            Delete existing data associated with KeychainItem.
        */
        set {
            if let valueToSave = newValue {
                save(item: valueToSave)
            } else {
                deleteItem()
            }
        }
    }

    // MARK: - Initialization

    init(service: String,
         key: String,
         accessGroup: String? = nil,
         keychainLevel: KeychainLevel,
         keyConstructor: KeyConstructor,
         keychainItemClass: KeychainItemClass) {
        self.service = service
        self.key = key
        self.accessGroup = accessGroup
        self.keychainLevel = keychainLevel
        self.keyConstructor = keyConstructor
        self.keychainItemClass = keychainItemClass
    }

    // MARK: - Private (Keychain access)

    /// Finds the item that matches the service, key and access group.
    private func readItem() -> Data? {
        NSLog("Read item with key: \(key)")
        /*
         Build a query to find the item that matches the service, key and
         access group.
         */
        var query = KeychainItem.keychainQuery(withService: service,
                                               key: key,
                                               accessGroup: accessGroup,
                                               keychainLevel: keychainLevel,
                                               keyConstructor: keyConstructor,
                                               keychainItemClass: keychainItemClass)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // Check the return status
        guard status != errSecItemNotFound else {
            NSLog("Data not found. \(status) for \(self)")
            return nil
        }
        guard status == errSecSuccess else {
            NSLog("Unknown error: \(status) for \(self)")
            return nil
        }

        guard let existingItem = queryResult as? [String: AnyObject],
            let itemData = existingItem[kSecValueData as String] as? Data
            else {
                NSLog("Unexpected data during casting: \(status) for \(self))")
                return nil
        }

        return itemData

    }
    /// Checks if an item exists — updates it, if not — creates a new item.
    private func save(item: Data) {
        // Check for an existing item in the keychain.
        if data != nil {
            NSLog("Update item with key: \(key)")
            // Update the existing item with the new data.
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = item as AnyObject?

            let query = KeychainItem.keychainQuery(withService: service,
                                                   key: key,
                                                   accessGroup: accessGroup,
                                                   keychainLevel: keychainLevel,
                                                   keyConstructor: keyConstructor,
                                                   keychainItemClass: keychainItemClass)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

            guard status != errSecItemNotFound else {
                NSLog("Item not found \(status) for \(self)")
                return
            }
            guard status == errSecSuccess else {
                NSLog("Unhandled error \(status) for \(self)")
                return
            }
        } else {
            NSLog("Save (new) item with key: \(key)")
            /*
             No password was found in the keychain. Create a dictionary to save
             as a new keychain item.
             */
            var newItem = KeychainItem.keychainQuery(withService: service,
                                                     key: key,
                                                     accessGroup: accessGroup,
                                                     keychainLevel: keychainLevel,
                                                     keyConstructor: keyConstructor,
                                                     keychainItemClass: keychainItemClass)
            newItem[kSecValueData as String] = item as AnyObject?

            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)

            guard status == errSecSuccess else {
                NSLog("Unhandled error \(status) for \(self)")
                return
            }
        }
    }

    /// Delete the existing item from the keychain.
    private func deleteItem() {
        NSLog("Cleared item for key: \(key)")
        let query = KeychainItem.keychainQuery(withService: service,
                                               key: key,
                                               accessGroup: accessGroup,
                                               keychainLevel: keychainLevel,
                                               keyConstructor: keyConstructor,
                                               keychainItemClass: keychainItemClass)
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            NSLog("Unhandled error \(status) for \(self)")
            return
        }
    }

    /// Creates new query for each request to keychain
    private static func keychainQuery(withService service: String,
                                      key: String? = nil,
                                      accessGroup: String? = nil,
                                      keychainLevel: KeychainLevel,
                                      keyConstructor: KeyConstructor,
                                      keychainItemClass: KeychainItemClass) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = keychainItemClass.cfString
        query[kSecAttrService as String] = service as AnyObject?
        // Change kSecAttrAccessible very carefully, it can break background application work.
        query[kSecAttrAccessible as String] = keychainLevel.cfString

        // The key is nil when we want to retrieve the list of the keys inside the keychain
        if let key = key {
            let queryKey = keyConstructor.createQueryKey(from: key,
                                                         keychainLevel: keychainLevel,
                                                         keychainItemClass: keychainItemClass)
            query[kSecAttrAccount as String] = queryKey as AnyObject?
        }

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }

        return query
    }

    // MARK: - Static

    /// This list contains only key items defined with the preferences
    /// in KeychainConfiguration class
    static func storedItems(using keychainConfiguration: KeychainConfiguration) -> [KeychainItem] {
        return keychainItems(forService: keychainConfiguration.serviceName,
                             accessGroup: keychainConfiguration.accessGroup,
                             keychainLevel: keychainConfiguration.keychainLevel,
                             keyConstructor: keychainConfiguration.keyConstructor,
                             keychainItemClass: keychainConfiguration.keychainItemClass)
    }
    /// Return item defined in keychain service for wanted configuration
    static func retrieve(forKey key: String,
                         using keychainConfiguration: KeychainConfiguration) -> KeychainItem {
        return KeychainItem(service: keychainConfiguration.serviceName,
                            key: key,
                            accessGroup: keychainConfiguration.accessGroup,
                            keychainLevel: keychainConfiguration.keychainLevel,
                            keyConstructor: keychainConfiguration.keyConstructor,
                            keychainItemClass: keychainConfiguration.keychainItemClass)
    }
    /// Finds the item that matches the service and access group.
    static func keychainItems(forService service: String,
                              accessGroup: String? = nil,
                              keychainLevel: KeychainLevel,
                              keyConstructor: KeyConstructor,
                              keychainItemClass: KeychainItemClass) -> [KeychainItem] {
        // Build a query for all items that match the service and access group.
        var query = KeychainItem.keychainQuery(withService: service,
                                               accessGroup: accessGroup,
                                               keychainLevel: keychainLevel,
                                               keyConstructor: keyConstructor,
                                               keychainItemClass: keychainItemClass)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse

        // Fetch matching items from the keychain.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // If no items were found, return an empty array.
        guard status != errSecItemNotFound else {
            NSLog("Items not found \(status) for \(self)")
            return []
        }

        guard status == errSecSuccess else {
            NSLog("Unhandled error \(status) for \(self)")
            return []
        }

        // Cast the query result to an array of dictionaries.
        guard let resultData = queryResult as? [[String: AnyObject]] else {
            NSLog("Unexpected data: \(status) for \(self)")
            return []
        }

        // Create a `KeychainItem` for each dictionary in the query result.
        var keychainItems = [KeychainItem]()
        for result in resultData {
            guard let key  = result[kSecAttrAccount as String] as? String else {
                NSLog("Unexpected data during casting: \(status) for \(self)")
                return []
            }

            let keychainItem = KeychainItem(service: service,
                                            key: key,
                                            accessGroup: accessGroup,
                                            keychainLevel: keychainLevel,
                                            keyConstructor: keyConstructor,
                                            keychainItemClass: keychainItemClass)
            keychainItems.append(keychainItem)
        }

        return keychainItems
    }
    /// Potentially dangerous function. It can delete all keychain data.
    /// Even accessGroup may be affected.
    static func resetKeychain() {
        deleteAllKeysForSecClass(kSecClassGenericPassword)
        deleteAllKeysForSecClass(kSecClassInternetPassword)
        deleteAllKeysForSecClass(kSecClassCertificate)
        deleteAllKeysForSecClass(kSecClassKey)
        deleteAllKeysForSecClass(kSecClassIdentity)
        NSLog("Cleaning all keychain items successfully completed")
    }
    private static func deleteAllKeysForSecClass(_ secClass: CFTypeRef) {
        let dict: [NSString: Any] = [kSecClass: secClass]
        let result = SecItemDelete(dict as CFDictionary)

        guard result == noErr || result == errSecItemNotFound else {
            NSLog("Problem with cleaning keychain items \(result) for \(self)")
            return
        }
    }
}

// MARK: - Array<KeychainItem>

extension Array where Element == KeychainItem {
    func convertToDictionary() -> [String: Any] {
        var dictionaryToUse = [String: Any]()
        for keychainItem in self {
            guard let item = keychainItem.data else {
                continue
            }
            dictionaryToUse.updateValue(item, forKey: keychainItem.key)
        }
        return dictionaryToUse
    }
}
