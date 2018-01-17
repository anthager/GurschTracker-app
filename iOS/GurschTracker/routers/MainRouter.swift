//
//  MainRouter.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-16.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import UIKit

class MainRouter: ControllerRouter {
	let from: Route
	let withIn: UINavigationController

	init(from: Route, withIn: UINavigationController) {
		self.from = from
		self.withIn = withIn
	}
	func route(to controllerToPresent: ViewController){
		switch from {
		case .login:
			print("from login")
		default:
			fatalError("errror in mainRouter")
		}
		withIn.pushViewController(controllerToPresent, animated: true)
	}
}
