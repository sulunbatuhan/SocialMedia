//
//  RegisterController.swift
//  DriftKit
//
//  Created by batuhan on 19.12.2023.
//

import UIKit
import SnapKit
import FirebaseAuth

final class RegisterController: UIViewController {
    
    var viewModel                    : RegisterViewModel?
    
    private let brandTitle           : UILabel = {
        let label                    = UILabel()
        label.text                   = "Social"
        label.font                   = UIFont.boldSystemFont(ofSize: 80)
        return label
    }()
    
    private lazy var userNameField   : UITextField = {
        let field                    = UITextField()
        field.placeholder            = "Username"
        field.autocorrectionType     = .no
        field.layer.masksToBounds    = true
        field.autocapitalizationType = .none
        field.returnKeyType          = .next
        return field
    }()
    
    private lazy var emailField:UITextField = {
        let field                    = UITextField()
        field.placeholder            = "Email"
        field.autocorrectionType     = .no
        field.layer.masksToBounds    = true
        field.autocapitalizationType = .none
        field.returnKeyType          = .next
        return field
    }()
    
    private lazy var passwordField   : UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.autocorrectionType     = .no
        field.layer.masksToBounds    = true
        field.autocapitalizationType = .none
        field.returnKeyType          = .next
        field.isSecureTextEntry = true
        return field
    }()
    
    private let logInButton          : UIButton = {
        let button                   = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.tintColor             = .white
        button.backgroundColor       = UIColor(named: "textColor")
        button.layer.cornerRadius    = 10
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        return button
    }()
    
    private lazy var textFieldStack : UIStackView = {
        let stack                   = UIStackView(arrangedSubviews: [userNameField,emailField,passwordField,logInButton])
        stack.axis                  = .vertical
        stack.spacing               = 24
        stack.distribution          = .fillEqually
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
    private func setLayout(){
        view.addSubviews(brandTitle,textFieldStack)
        
        brandTitle.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(200)
            make.top.equalTo(view.snp_topMargin)
        }
        
        textFieldStack.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(200)
            make.top.equalTo(brandTitle.snp_bottomMargin)
        }
    }
    
    @objc func didTapRegister() {
        emailField.resignFirstResponder()
        userNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let username = userNameField.text, !username.isEmpty,
              let email    = emailField.text, !email.isEmpty,email.contains("@"),email.contains("."),
              let password = passwordField.text,!password.isEmpty,password.count > 6 else {
            
            return self.showAlert(message: "Boş isim giremezsiniz,mailinizi kontrol edin,şifreniz altı karakterden büyük olmalı!")
        }
        
        Task{
            let result  = await viewModel?.createNewUser(username: username, email: email, password: password)
            if result == false{
                self.showAlert(message: "Hata!Kullanıcı oluşturulamadı")
            }else{
                viewModel?.backToLogin()
                self.navigationController?.popViewController(animated: true)
            }
        }
        
            self.userNameField.text = ""
            self.emailField.text = ""
            self.passwordField.text = ""
        
        
    }
}

extension RegisterController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField       == userNameField {
            userNameField.becomeFirstResponder()
      
        }else if textField == emailField {
            emailField.becomeFirstResponder()
            
        }else {
            didTapRegister()
        }
        return true
    }
}
