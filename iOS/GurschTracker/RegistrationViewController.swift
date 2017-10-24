//
//  RegistrationViewController.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-10-21.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController, AuthValidation {

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var repeatPasswordTextField: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()
	}

	@IBAction func signUpButtonPressed(_ sender: UIButton) {
		signUp()
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateInitialViewController()
		self.present(controller!, animated: true, completion: nil)
	}
	//MARK: - actions
	private func signUp() -> Bool {

		guard let email = emailTextField.text, isValidEmail(emailTextField.text) else {
			print("email validation failed")
			return false
		}

		guard let password = passwordTextField.text, isValidPasswords(passwordTextField.text, repeatPasswordTextField.text) else {
			print("password validation failed")
			return false
		}

		var success = false
		Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
			if error != nil {
				print(error as Any)
				return
			}
			success = true
		}
		return success
	}

}

