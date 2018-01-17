//
//  AppRouter.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-16.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import UIKit
class AppRouter: Router {
	private var window: UIWindow!
	var navigationController = UINavigationController()

	func route(to route: Route) {

		let controllerToPresent = ViewControllerFactory.build(route: route,
														  with: self)
		let router = RouterFactory(navigationController: navigationController).build(from: route)
		router.route(to: controllerToPresent)

	}
	private func display(controller: UIViewController){
		let navigationController = UINavigationController(rootViewController: controller)
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
}
