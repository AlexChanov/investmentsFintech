//
//  AuthViewController.swift
//  AuthModule
//
//  Created by Максим Стегниенко on 24.02.2020.
//

import UIKit

public final class AuthViewController: UIViewController {
    // MARK: - Public properties
    
    private(set) public var viewModel: AuthViewModel?
    
    // MARK: - Private properties
    
    private let loginTextField = UITextField()
    private let passwordTextField = UITextField()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - ViewModelOwning

extension AuthViewController: ViewModelOwning {
    public typealias ViewModel = AuthViewModel
    
    public func configure(with model: AuthViewModel) -> Self {
        viewModel = model        
        return self
    }
}

// MARK: - Private

private extension AuthViewController {
    enum Layout {
        static let yOffset: CGFloat = -100
        static let textFieldSize = CGSize(width: 200, height: 40)
        static let offsetBetweenTextFields: CGFloat = 25
    }
    
    func setupLayout() {
        view.backgroundColor = .white
        
        loginTextField.delegate = self
        loginTextField.placeholder = "Login"
        loginTextField.textAlignment = .left
        loginTextField.textColor = .black
        loginTextField.keyboardType = .emailAddress
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.borderStyle = .roundedRect
        loginTextField.layer.borderColor = UIColor.clear.cgColor
        loginTextField.layer.borderWidth = 3
        
        view.addSubview(loginTextField)
        NSLayoutConstraint.activate([
            loginTextField.heightAnchor.constraint(equalToConstant: Layout.textFieldSize.height),
            loginTextField.widthAnchor.constraint(equalToConstant: Layout.textFieldSize.width),
            loginTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Layout.yOffset),
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        passwordTextField.layer.borderColor = UIColor.clear.cgColor
        passwordTextField.layer.borderWidth = 3
        passwordTextField.delegate = self
        passwordTextField.placeholder = "Password"
        passwordTextField.textAlignment = .left
        passwordTextField.textColor = .black
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.borderStyle = .roundedRect
        
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.heightAnchor.constraint(equalToConstant: Layout.textFieldSize.height),
            passwordTextField.widthAnchor.constraint(equalToConstant: Layout.textFieldSize.width),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor,
                                                   constant: Layout.offsetBetweenTextFields),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let text = (textField.text as NSString?) ?? ""
        let textFieldText = text.replacingCharacters(in: range, with: string)
        let textFieldType: AuthViewModel.TextFieldType
        
        if textField === loginTextField {
            textFieldType = .login(text: textFieldText)
        } else if textField === passwordTextField {
            textFieldType = .password(text: textFieldText)
        } else {
            return false
        }
        
        do {
            try currentViewModel.validated(with: textFieldType)
            textField.layer.borderColor = UIColor.green.cgColor
        } catch {
            textField.layer.borderColor = UIColor.red.cgColor
        }
        
        return true
    }
}
