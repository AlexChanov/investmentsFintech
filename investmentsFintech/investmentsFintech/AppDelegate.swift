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
        setupInitialModule()
        
        return true
    }
    
    // MARK: - Private methods
    
    private func setupInitialModule() {
        let viewController = AuthViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
