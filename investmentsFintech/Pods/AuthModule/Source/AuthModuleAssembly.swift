//
//  AuthModuleAssembly.swift
//  AuthModule
//
//  Created by Максим Стегниенко on 24.02.2020.
//

public final class AuthModuleAssembly {
    public static func assembleModule() -> AuthViewController {
        
        let viewModel = AuthViewModel()
        let view = AuthViewController().configure(with: viewModel)
        
        return view
    }
}

