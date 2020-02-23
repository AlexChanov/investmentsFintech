//
//  KeyConstructor.swift
//  InvestmentsFintech
//
//  Created by Vitaliy Pyatnikov on 23.02.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

// MARK: - KeyConstructor

/// This enum describes how keychain will be generated
/// If level prefix is used it will be concated
/// This is used due to remove keychain access level conflicts
/// The different levels return different value
enum KeyConstructor {

    // MARK: - Cases

    /// The security level should be concated as a prefix
    case useKeychainLevelPrefix
    /// Use the original key. Mostly is used for migration and debug cases
    case useRawKey

    // MARK: - Internal methods

    /// This method appends prefix
    /// The prefix is appended only when needed
    func createQueryKey(from key: String,
                        keychainLevel: KeychainLevel,
                        keychainItemClass: KeychainItemClass) -> String {
        switch self {
        case .useKeychainLevelPrefix:
            let prefix = "\(keychainItemClass.rawValue)-\(keychainLevel.rawValue)"
            if key.starts(with: prefix) {
                return key
            } else {
                return "\(prefix)-\(key)"
            }
        case .useRawKey:
            return key
        }
    }
}
