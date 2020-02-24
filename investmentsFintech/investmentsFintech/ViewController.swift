//
//  ViewController.swift
//  InvestmentsFintech
//
//  Created by Алексей on 20.02.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

import UIKit
import AuthModule

class ViewController: UIViewController {

    let authView = AuthViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let view = R.storyboard.launchScreen()
        view.backgroundColor = authView.view.backgroundColor
    }

}
