//
//  AppDelegate.swift
//  InvestmentsFintech
//
//  Created by Алексей on 20.02.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

import UIKit
import AuthModule

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        checkInitialModule()
        
        return true
    }
    
    // MARK: - Private methods
    
    private func checkInitialModule() {
        
        let storage = KeychainDataStorage()
        let key = "MyAccountPassword"
        
        guard let _ = storage.getData(forKey: key) else {
            let viewController = AuthModuleAssembly.assembleModule(output: self)
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()

            return
        }
        
        let verificationViewController = PINVerificationViewController()
        window?.rootViewController = verificationViewController
        window?.makeKeyAndVisible()
    }
}

// MARK: - AuthModuleOutput

extension AppDelegate: AuthModuleOutput {
    func showPinModule() {
        let verificationViewController = PINViewController()
        guard let vc = window?.rootViewController as? UINavigationController else { return }
        vc.pushViewController(verificationViewController,
                              animated: true)
    }

    func showNextModule() {
        let viewController = ViewController()
        guard let vc = window?.rootViewController as? UINavigationController else { return }
        vc.pushViewController(viewController,
                              animated: true)
    }
}
