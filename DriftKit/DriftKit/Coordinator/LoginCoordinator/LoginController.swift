//
//  LoginController.swift
//  DriftKit
//
//  Created by batuhan on 19.12.2023.
//

import UIKit
import SnapKit
import JGProgressHUD

class LoginController: UIViewController {
    
    var viewModel : LoginViewModel?
    
    private let brandTitle           : UILabel = {
        let label                    = UILabel()
        label.text                   = "Social"
        label.font                   = UIFont.boldSystemFont(ofSize: 80)
        return label
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

    private lazy var passwordField:UITextField = {
        let field                    = UITextField()
        field.placeholder            = "Password"
        field.isSecureTextEntry      = true
        field.autocorrectionType     = .no
        field.layer.masksToBounds    = true
        field.autocapitalizationType = .none
        field.returnKeyType          = .next
        return field
    }()

    private let logInButton          : UIButton = {
        let button                   = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.tintColor             = .white
        button.backgroundColor       = UIColor(named: "textColor")
        button.layer.cornerRadius    = 10
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    private let newAccount           : UIButton = {
        let newAccount               = UIButton(type: .system)
        newAccount.setTitle("New Account", for: .normal)
        newAccount.addTarget(self, action: #selector(moveNewAccountPage), for: .touchUpInside)
        return newAccount
    }()
    
    private lazy var textFieldStack : UIStackView = {
        let stack                   = UIStackView(arrangedSubviews: [emailField,passwordField,logInButton])
        stack.axis                  = .vertical
        stack.spacing               = 24
        stack.distribution          = .fillEqually
        return stack
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        viewModel?.checkConnection()
        viewModel?.onError = { [weak self] errorText in
            DispatchQueue.main.async {
                self?.showAlert(message: errorText)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
    
    @objc private func didTapLoginButton(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email    = emailField.text, !email.isEmpty,email.contains("@"),email.contains("."),
              let password = passwordField.text,!password.isEmpty,password.count > 6 else {
            self.showAlert(message: "Hatalı giriş yaptınız")
            self.emailField.text = ""
            self.passwordField.text = ""
            return
        }
        Task{
//           await viewModel?.logIn(email:email,password:password){ result in
//               if result == false {
//                   self.showAlert(message: "Giriş Yapılamıyor")
//               }
//            }
         let result   = await viewModel?.logIn(email: email, password: password)
            if result == false {
                self.showAlert(message: "Giriş Yapılamıyor")
            }else {
                viewModel?.coordinator?.showTabbarController()
            }
        }
        
        self.emailField.text = ""
        self.passwordField.text = ""
        
//        self.viewModel?.logIn(email: email, password: password) { [weak self] success in
//            if success{
//                let tabbarController = TabbarController()
//                tabbarController.modalPresentationStyle = .fullScreen
//                self?.present(tabbarController,animated: true)
//            }else {
//                self?.showAlert(message: "Email veya şifre yanlış")
//                self?.emailField.text = ""
//                self?.passwordField.text = ""
//            }
//        }
    }
    
    @objc private func moveNewAccountPage(){
        viewModel?.createNewAccount()
    }
    
    
    private func setLayout(){
        view.addSubviews(brandTitle,textFieldStack,newAccount)
        brandTitle.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(200)
            make.top.equalTo(view.snp_topMargin)
        }
        textFieldStack.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(160)
            make.top.equalTo(brandTitle.snp_bottomMargin)
        }
        newAccount.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(20)
            make.bottom.equalTo(view.snp_bottomMargin)
        }
    }
}


extension UIViewController {
    func showAlert(message:String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Kapat", style: .cancel)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}
