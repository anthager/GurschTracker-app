//
//  LoginRouter.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-17.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import UIKit

class LoginRouter: ControllerRouter {
	let from: Route
	let withIn: UINavigationController

	init(from: Route, withIn: UINavigationController) {
		self.from = from
		self.withIn = withIn
	}
	func route(to controllerToPresent: ViewController){
		withIn.pushViewController(controllerToPresent, animated: true)
	}
}
