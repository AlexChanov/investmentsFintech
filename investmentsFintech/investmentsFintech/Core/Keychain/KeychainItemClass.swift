//
//  KeychainItemClass.swift
//  InvestmentsFintech
//
//  Created by Vitaliy Pyatnikov on 23.02.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

import Foundation

// MARK: - KeychainItemClass

/// This is a mirror of native 'keychain item class' class.
enum KeychainItemClass: String {

    // MARK: - Cases

    case genericPassword
    case internetPassword
    case certificate
    case key
    case identity

    // MARK: - Computed variables

    var cfString: CFString {
        switch self {
        case .genericPassword:
            return kSecClassGenericPassword
        case .internetPassword:
            return kSecClassInternetPassword
        case .certificate:
            return kSecClassCertificate
        case .key:
            return kSecClassKey
        case .identity:
            return kSecClassIdentity
        }
    }
}
