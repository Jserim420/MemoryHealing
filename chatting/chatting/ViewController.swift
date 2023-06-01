//
//  ViewController.swift
//  chatting
//
//  Created by 장세림 on 2023/05/26.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseCore
import MessageKit

class ViewController: BaseViewController {


    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func Login(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty else {
            showAlert(message: "이메일을 입력해주세요.")
            return
        }
        guard let password = passwordField.text, !password.isEmpty else {
            showAlert(message: "이메일을 입력해주세요.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                let channel = Channel(name: "Default Channel") // 채널 정보 생성
                                let viewController = ChatViewController(channel: channel) // ChatViewController 인스턴스 생성 및 채널 정보 전달
                                self.navigationController?.pushViewController(viewController, animated: true) // ChatViewController로 전환
                            
            }
        }
        

        
        
    }
    
    @IBAction func SignUpBtn(_ sender: Any){
    }
    
    
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {

      var window: UIWindow?

      func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
          [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        return true
      }
    }
    
    private func showAlert(message: String) {
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
}

