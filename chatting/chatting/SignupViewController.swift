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
    
    @IBAction func SignUp(_ sender: UIButton) {
        guard let email = signupEmailTextField.text, !email.isEmpty else {
            showAlert(message: "이메일을 입력해주세요.")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "비밀번호를 입력해주세요.")
            return
        }
        
        
        // 이후의 코드 실행
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                // self.performSegue(withIdentifier: "SignUp", sender: self)
            }
        }
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                // self.performSegue(withIdentifier: "SignUp", sender: self)
            }
        }
        
    }
    
    private func showAlert(message: String) {
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }

}

