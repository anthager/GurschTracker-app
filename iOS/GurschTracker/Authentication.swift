//
//  Authentication.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-10-21.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit

protocol AuthValidation {
	func isValidPasswords(_ password1: String?, _ password2: String? ) -> Bool
	func isValidEmail(_ email: String?) -> Bool
	func isAValidPassword(_ password: String?) -> Bool
}

extension AuthValidation {
	func isValidPasswords(_ password1: String?, _ password2: String? ) -> Bool {
		return password1 == password2 && isAValidPassword(password1) && isAValidPassword(password2)
	}
	func isAValidPassword(_ password: String?) -> Bool {
		return true
	}
	func isValidEmail(_ email: String?) -> Bool {
		guard var email = email else {
			print("no email found")
			return false
		}
		email = email.lowercased()
		guard email.contains("@") else {
			print("\(email) didnt contain @")
			return false
		}
		return true
	}
}
extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}

	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}
