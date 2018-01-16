//
//  MainRouter.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-16.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import UIKit

protocol Router {
	func route(to: Routes, from: UIViewController?)
	weak var viewModel: ViewModelP! {get set}
}

enum Routes {
	case login
	case registration
	case main
	case addOpponent
	case addSession
}

class MainRouter: Router {
	weak var viewModel: ViewModelP!
	func route(to: Routes, from: UIViewController?) {
		
	}
}

class LoginRouter: Router {
	func route(to: Routes, from: UIViewController?) {

	}

	var viewModel: ViewModelP!

}

class AppRouter: Router {
	weak var viewModel: ViewModelP!
	var window: UIWindow?
	
	func route(to: Routes, from: UIViewController?) {
		switch to {
		case .main: //TODO: fix
			let vm = MainViewModel()
			let controller = ViewControllerFactory.build(view: .main) as! MainViewController
			let router = MainRouter()
			router.viewModel = vm
			controller.router = router

			display(controller: controller)
		case .login:
			let vm = LoginViewModel()
			let controller = ViewControllerFactory.build(view: .login) as! LoginViewController
			let router = LoginRouter()
			router.viewModel = vm
			controller.router = router

			display(controller: controller)
		default:
			fatalError("invalid route in appRouter")
		}
	}
	private func display(controller: UIViewController){
		let navigationController = UINavigationController(rootViewController: controller)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}
}

