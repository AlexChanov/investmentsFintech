//
//  AuthModuleAssembly.swift
//  AuthModule
//
//  Created by Максим Стегниенко on 24.02.2020.
//

public final class AuthModuleAssembly {
    public static func assembleModule(output: AuthModuleOutput) -> UINavigationController {
        
        let view = AuthViewController()
        let router = AuthModuleRouter(output: output)
        let viewModel = AuthViewModel(router: router)
        
        view.configure(with: viewModel)
        view.navigationItem.title = "Enter"
     
        return UINavigationController(rootViewController: view)
    }
}

