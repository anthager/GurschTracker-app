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
	let alertController = UIAlertController(title: "Login failed", message: "Wrong password or email", preferredStyle: .alert)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()
		alertController.addAction(action1)
		setupPasswordTextField()
	}
	
	@IBAction func signUpButtonPressed(_ sender: UIButton) {
		guard let email = emailTextField.text, isValidEmail(emailTextField.text) else {
			print("invalid email entered")
			self.present(alertController, animated: true, completion: nil)
			return
		}
		guard let password = passwordTextField.text, isAValidPassword(passwordTextField.text) else {
			print("invalid password entered")
			return
		}
		Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
			if error != nil {
				print("faild due to \(error as Any)")
				self.present(self.alertController, animated: true, completion: nil)
				return
			}
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateInitialViewController() as! ViewController
			self.navigationController?.setViewControllers([controller], animated: true)
		}
	}

	//MARK: - actions
	let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
	}

	private func setupPasswordTextField(){
		passwordTextField.autocorrectionType = .no
		passwordTextField.autocapitalizationType = .none
		passwordTextField.isSecureTextEntry = true
	}

	//MARK: - ui setup
	
	
}

