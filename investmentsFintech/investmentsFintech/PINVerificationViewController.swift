//
//  qViewController.swift
//  InvestmentsFintech
//
//  Created by Алексей ]Чанов on 25/02/2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

import UIKit

class PINVerificationViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis  = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing   = 16.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text  = "Сreate password"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 3
        textField.delegate = self
        textField.placeholder = "Enter pin"
        textField.textAlignment = .left
        textField.textColor = .black
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private var sighInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.isEnabled = false
        button.alpha = 0.5
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(transitionNextView), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(sighInButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: view.frame.height / 6),
            stackView.widthAnchor.constraint(equalToConstant: view.frame.width / 2 )
        ])
    }
    
    @objc private func transitionNextView() {
        
        let storage = KeychainDataStorage()
        let key = "MyAccountPassword"
        guard let pass = storage.getData(forKey: key) else {
            showAlert(message: "There is no data for \(key) in Keychain")
            return
        }
        
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.view.backgroundColor = .white
        present(vc, animated: true, completion: nil)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Upps", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension PINVerificationViewController: UITextFieldDelegate {}
