//
//  AuthViewModel.swift
//  AuthModule
//
//  Created by Максим Стегниенко on 25.02.2020.
//

import Foundation

public final class AuthViewModel {
    private(set) var loginIsValid = false
    private(set) var passwordIsValid = false
    
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
                switch type {
                    case .login:
                        loginIsValid = false
                    case .password:
                        passwordIsValid = false
                }
                
                throw type.error
            }
        } catch {
            switch type {
                case .login:
                    loginIsValid = false
                case .password:
                    passwordIsValid = false
            }
            throw type.error
        }
        
        switch type {
            case .login:
                loginIsValid = true
            case .password:
                passwordIsValid = true
        }
    
        return type.text
    }
}
