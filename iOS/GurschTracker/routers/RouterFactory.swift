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
	private let route: Route
	
	init(withIn navigationController: UINavigationController, from: Route) {
		self.navigationController = navigationController
		self.route = from
	}
	
	func build(to route: Route) -> ControllerRouter {
		switch route {
		case .main:
			return MainRouter(from: route, withIn: navigationController)
		case .login:
			return LoginRouter(from: route, withIn: navigationController)
		default:
			fatalError("bad route in routerFactory")
		}
	}
}
