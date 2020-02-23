//
//  KeychainConfiguration.swift
//  InvestmentsFintech
//
//  Created by Vitaliy Pyatnikov on 23.02.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

import Foundation

// MARK: - KeychainConfiguration

/// Enumeration that defines the service and access group to be used by the app
enum KeychainConfiguration {

    // MARK: - Cases

    /// Standartly used keychain configuration
    case standart

    // MARK: - Computed properties

    /// Keychain service name
    var serviceName: String {
        switch self {
        case .standart:
            // TODO: add InvestmentsFintech getter from info.plist
            return "keychain.InvestmentsFintech"
        }
    }

    /*
     Not specifying an access group to use with `KeychainItem` instances
     will create items specific to each app.
     https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps
     Quote: "If you don’t specify any access group,
     keychain services applies your app’s default access group,
     which is the first group named in the concatenated list of
     groups described in Set Your App’s Access Groups."
     */
    var accessGroup: String? {
        switch self {
        case .standart:
            return nil
        }
    }
    /// This setups a specific security level inside the application
    var keychainLevel: KeychainLevel {
        switch self {
        case .standart:
            return .afterFirstUnlock
        }
    }
    /// This is how the keychain database generate query request key
    /// Whether it uses original key or concates the keychain level prefix
    var keyConstructor: KeyConstructor {
        switch self {
        case .standart:
            return .useKeychainLevelPrefix
        }
    }
    var keychainItemClass: KeychainItemClass {
        return .genericPassword
    }
}
