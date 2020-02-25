//
//  AuthModuleRouter.swift
//  AuthModule
//
//  Created by Максим Стегниенко on 25.02.2020.
//

import Foundation

final class AuthModuleRouter {
    private weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension AuthModuleRouter {
    func showPinModule() {
        print("showPinModule")
    }
    
    func showNextModule() {
        print("showNextModule")
    }
}
