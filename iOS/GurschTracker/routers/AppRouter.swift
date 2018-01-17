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

	func route(to: Route, from: Route, data: [String:Any]) {

		let controllerToPresent = ViewControllerFactory.build(to: to, with: self)
		let router = RouterFactory(withIn: navigationController, from: ).build(to: to)
		router.route(to: controllerToPresent)

	}
	private func display(controller: UIViewController){
		let navigationController = UINavigationController(rootViewController: controller)
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
}
