//
//  LoginViewController.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-10-21.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var signinButton: UIButton!
	@IBOutlet weak var signupButton: UIButton!
	@IBOutlet weak var loginTextField: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()

	}

	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if ((segue.destination as? ViewController) != nil) {
			login()
		}
	}

	private func login() {
		guard let email = emailValidation(email: emailTextField.text) else {
			print("no email entered")
			return
		}
		guard let password = passwordTextField.text else {
			print("invalid password")
			return
		}
		Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
			if error != nil {
				print(error.debugDescription)
			}
		}

	}

	//MARK: - validation
	private func emailValidation(email: String?) -> String?{
		guard var email = email else {
			print("no email found")
			return nil
		}
		email = email.lowercased()
		guard email.contains("@") else {
			return nil
		}
		return email
	}

}
