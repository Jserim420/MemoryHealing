//
//  SignupViewController.swift
//  chatting
//
//  Created by 장세림 on 2023/05/26.
//

import Foundation
import FirebaseAuth
import UIKit

class SignupViewController: ViewController {
    @IBOutlet weak var signupEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signup(_ sender: UIButton) {
        guard let email = signupEmailTextField.text, !email.isEmpty else {
            // 이메일 텍스트 필드가 비어있거나 nil일 경우 처리
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            // 패스워드 텍스트 필드가 비어있거나 nil일 경우 처리
            return
        }
        
        // 이후의 코드 실행
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "SignUp", sender: self)
            }
        }
    }

}

