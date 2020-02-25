//
//  AuthViewModel.swift
//  AuthModule
//
//  Created by Максим Стегниенко on 25.02.2020.
//

import Foundation

public final class AuthViewModel {
    enum TextFieldType {
        case login(text: String)
        case password(text: String)
        
        var text: String {
            switch self {
                case .login(let text):
                    return text
                case .password(let text):
                    return text
            }
        }
        
        var pattern: String {
            switch self {
                case .login:
                    return "^[A-Za-z]{3,20}$"
                case .password:
                    return "^[A-Z0-9a-z._%+-]{8,20}$"
            }
        }
        
        var error: ValidationError {
            switch self {
                case .login:
                    return .login
                case .password:
                    return .password
            }
        }
    }
    
    // MARK: - Public methods
    
    @discardableResult
    func validated(with type: TextFieldType) throws -> String {
        do {
            let range = NSRange(location: 0, length: type.text.count)
            if try NSRegularExpression(
                pattern: type.pattern,
                options: .caseInsensitive
            ).firstMatch(in: type.text, options: [], range: range) == nil {
                throw type.error
            }
        } catch {
            throw type.error
        }
        
        return type.text
    }
}
