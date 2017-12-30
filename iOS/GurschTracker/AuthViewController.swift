//
//  AuthViewController.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-12-30.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		let authUI = FUIAuth.defaultAuthUI()
		authUI?.delegate = self

		let authViewController = authUI!.authViewController()
		present(authViewController, animated: false, completion: nil)
    }
}

extension AuthViewController: FUIAuthDelegate {
	func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
		let hej = 1
	}
}
