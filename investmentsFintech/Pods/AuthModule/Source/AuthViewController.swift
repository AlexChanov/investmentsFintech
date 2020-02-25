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
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Login"
        textField.textAlignment = .left
        textField.textColor = .black
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 3
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 3
        textField.delegate = self
        textField.placeholder = "Password"
        textField.textAlignment = .left
        textField.textColor = .black
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let pinToggle = UISwitch()
    private lazy var sighInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.5
        button.backgroundColor = .lightGray
        return button
    }()
    
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
        static let buttonSize = CGSize(width: 80, height: 50)
        static let yOffset: CGFloat = -100
        static let textFieldSize = CGSize(width: 200, height: 40)
        static let offsetBetweenTextFields: CGFloat = 25
    }
    
    func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(loginTextField)
        NSLayoutConstraint.activate([
            loginTextField.heightAnchor.constraint(equalToConstant: Layout.textFieldSize.height),
            loginTextField.widthAnchor.constraint(equalToConstant: Layout.textFieldSize.width),
            loginTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Layout.yOffset),
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.heightAnchor.constraint(equalToConstant: Layout.textFieldSize.height),
            passwordTextField.widthAnchor.constraint(equalToConstant: Layout.textFieldSize.width),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor,
                                                   constant: Layout.offsetBetweenTextFields),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        pinToggle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pinToggle)
        NSLayoutConstraint.activate([
            pinToggle.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                           constant: Layout.offsetBetweenTextFields),
            pinToggle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(sighInButton)
        NSLayoutConstraint.activate([
            sighInButton.heightAnchor.constraint(equalToConstant: Layout.buttonSize.height),
            sighInButton.widthAnchor.constraint(equalToConstant: Layout.buttonSize.width),
            sighInButton.topAnchor.constraint(equalTo: pinToggle.bottomAnchor,
                                                  constant: Layout.offsetBetweenTextFields),
            sighInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        
        if currentViewModel.loginIsValid, currentViewModel.passwordIsValid {
            sighInButton.alpha = 1
            sighInButton.isEnabled = true
        } else {
            sighInButton.alpha = 0.5
            sighInButton.isEnabled = false
        }
        
        return true
    }
}
