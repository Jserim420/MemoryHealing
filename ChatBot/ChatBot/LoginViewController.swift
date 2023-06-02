//
//  NameViewController.swift
//  ChatBot
//
//  Created by 장세림 on 2023/06/02.
//  Copyright © 2023 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: MainViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func login(_ sender: UIButton) {
        guard nameTextField.text != nil else { return }
        guard passwordTextField.text != nil else { return }
        }
    }
