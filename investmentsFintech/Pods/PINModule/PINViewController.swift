//
//  PINCreateViewController.swift
//  AuthModule
//
//  Created by Алексей on 25.02.2020.
//

import UIKit

class PINViewController: UIViewController {

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
            label.text  = "Введите пароль"
            label.textAlignment = .center
            return label
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
             textField.borderStyle = .roundedRect
             return textField
         }()
         
         private var sighInButton: UIButton = {
             let button = UIButton()
             button.setTitle("Войти", for: .normal)
             button.isEnabled = false
             button.alpha = 0.5
             button.backgroundColor = .lightGray
             return button
         }()
        
      
        private lazy var repasswordTextField: UITextField = {
             let textField = UITextField()
             textField.layer.borderColor = UIColor.clear.cgColor
             textField.layer.borderWidth = 3
             textField.delegate = self
             textField.placeholder = "Re-password"
             textField.textAlignment = .left
             textField.textColor = .black
             textField.keyboardType = .default
             textField.isSecureTextEntry = true
             textField.borderStyle = .roundedRect
             return textField
         }()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            stackView.addArrangedSubview(textLabel)
            stackView.addArrangedSubview(passwordTextField)
            stackView.addArrangedSubview(repasswordTextField)
            stackView.addArrangedSubview(sighInButton)
            
            view.addSubview(stackView)

            
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                stackView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.3),
                stackView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8 )
                ])
        }
    }


    // MARK: - UITextFieldDelegate

    extension PINViewController: UITextFieldDelegate {
        public func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            
                  guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                      return false
              }
              let substringToReplace = textFieldText[rangeOfTextToReplace]
              let count = textFieldText.count - substringToReplace.count + string.count
              return count <= 10
        }
    }
