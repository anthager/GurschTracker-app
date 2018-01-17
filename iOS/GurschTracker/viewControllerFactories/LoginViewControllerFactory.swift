//
//  LoginViewControllerFactory.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-16.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import UIKit

class LoginViewControllerFactory: ControllerFactory {

	private let router: Router
	init(with router: Router){
		self.router = router
	}
	func build() -> ViewController {
		let vm = LoginViewModel()
		let storyboard = UIStoryboard(name: "Auth", bundle: nil)
		let controller = storyboard.instantiateInitialViewController() as! LoginViewController
		controller.viewModel = vm
		controller.router = router

		return controller
	}
}
