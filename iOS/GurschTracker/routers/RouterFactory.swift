//
//  RouterFactory.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-17.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import UIKit
class RouterFactory {
	private let navigationController: UINavigationController!
	private var controller: UIViewController? {
		return navigationController.topViewController
	}
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func build(from route: Route) -> ControllerRouter {
		switch route {
		case .main:
			return MainRouter(from: controller!, withIn: navigationController)
		case .login:
			return LoginRouter(from: controller!, withIn: navigationController)
		default:
			fatalError("bad route in routerFactory")
		}
	}
}
