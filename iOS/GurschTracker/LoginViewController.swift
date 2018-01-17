//
//  LoginViewController.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-10-21.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: ViewController, AuthValidation {
	//MARK: props
	@IBOutlet weak var adminButton: UIButton!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var signinButton: UIButton!
	@IBOutlet weak var signupButton: UIButton!
	@IBOutlet weak var loginTextField: UITextField!

	let alertController = UIAlertController(title: "Login failed", message: "Wrong password or email", preferredStyle: .alert)

	//MARK: - load
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()
		signupButtonSetup()
		alertController.addAction(action1)
		setupPasswordTextField()
		self.navigationController?.navigationBar.isHidden = false
	}

	@IBAction func signInButtonPressed(_ sender: UIButton) {
		guard let email = emailTextField.text, isValidEmail(emailTextField.text) else {
			print("invalid email entered")
			self.present(alertController, animated: true, completion: nil)
			return
		}
		guard let password = passwordTextField.text, isAValidPassword(passwordTextField.text) else {
			print("invalid password entered")
			return
		}
		Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
			if error != nil {
				print("faild due to \(error as Any)")
				self.present(self.alertController, animated: true, completion: nil)
				return
			}
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateInitialViewController() as! MainViewController
			self.navigationController?.setViewControllers([controller], animated: true)
		}
	}

	//MARK: - actions
	let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
	}

	@objc private func switchToSignUp(){
		let storyboard = UIStoryboard(name: "Registration", bundle: nil)
		let controller = storyboard.instantiateInitialViewController() as! RegistrationViewController
		navigationController?.pushViewController(controller, animated: true)
	}

	//MARK: - ui setup
	private func signupButtonSetup(){
		signupButton.addTarget(self, action: #selector(switchToSignUp), for: .touchUpInside)
	}

	func setupPasswordTextField(){
		passwordTextField.autocorrectionType = .no
		passwordTextField.autocapitalizationType = .none
		passwordTextField.isSecureTextEntry = true
	}
}
