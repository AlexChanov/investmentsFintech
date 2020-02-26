//
//  AuthModuleRouter.swift
//  AuthModule
//
//  Created by Максим Стегниенко on 25.02.2020.
//

import Foundation

public protocol AuthModuleOutput: AnyObject {
    func showPinModule()
    func showNextModule()
}

final class AuthModuleRouter {
    private weak var output: AuthModuleOutput?
    
    // MARK: - Init
    
    init(output: AuthModuleOutput?) {
        self.output = output
    }
}

extension AuthModuleRouter {
    func showPinModule() {
        output?.showPinModule()
    }
    
    func showNextModule() {
        output?.showNextModule()
    }
}
