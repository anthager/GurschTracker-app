//
//  ViewControllerFactory.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-16.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import UIKit

class ViewControllerFactory{
	static func build(view: Routes) -> UIViewController{
		switch view {
		case .main:
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateInitialViewController()
			return controller!
		case .login:
			let storyboard = UIStoryboard(name: "Auth", bundle: nil)
			let controller = storyboard.instantiateInitialViewController()
			return controller!
		default:
			fatalError("invalid route in appRouter")
		}
	}
}
