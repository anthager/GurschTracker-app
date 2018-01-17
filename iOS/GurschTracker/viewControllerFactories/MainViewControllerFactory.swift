//
//  MainViewControllerFactory.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-16.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import UIKit

class MainViewControllerFactory: ControllerFactory {

	private let router: Router
	init(with router: Router){
		self.router = router
	}
	func build() -> ViewController {
		let vm = MainViewModel()
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateInitialViewController() as! MainViewController
		controller.viewModel = vm
		controller.router = router

		return controller
	}
}
