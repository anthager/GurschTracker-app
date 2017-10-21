//
//  LoginViewController.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-10-21.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, AuthValidation {

	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var signinButton: UIButton!
	@IBOutlet weak var signupButton: UIButton!
	@IBOutlet weak var loginTextField: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()

	}

	private func login() {
		guard let email = emailTextField.text, isValidEmail(emailTextField.text) else {
			print("invalid email entered")
			return
		}
		guard let password = passwordTextField.text, isAValidPassword(passwordTextField.text) else {
			print("invalid password entered")
			return
		}
		Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
			if error != nil {
				print(error as Any)
			}
		}
	}
}
