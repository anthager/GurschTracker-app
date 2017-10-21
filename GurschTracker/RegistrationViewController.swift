//
//  RegistrationViewController.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-10-21.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: UIViewController {

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var repeatPasswordTextField: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	//MARK: - actions
	private func signUp() {

		guard let email = emailValidation(email: emailTextField.text) else {
			print("email validation failed")
			return
		}

		guard let password = passwordValidation(password1: passwordTextField.text, password2: repeatPasswordTextField.text) else {
			print("password validation failed")
			return
		}

		Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
			if err != nil {
				print(err.debugDescription)
				return
			}
			guard let uid = user?.uid else {
				fatalError("just init user had no uid, something is very fucked up")
			}
			let userData: [String : Any] = ["email" : user?.email ?? "", "uid" : uid]
			Database.database().reference().child("users").child(uid).updateChildValues(userData)
		}
	}
	//MARK: - validation
	private func passwordValidation(password1: String?, password2: String? ) -> String?{
		guard password1 == password2 else {
			return nil
		}

		return password1
	}

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


	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		signUp()
	}

}

