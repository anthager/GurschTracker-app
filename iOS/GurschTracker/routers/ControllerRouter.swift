//
//  ControllerRouter.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-17.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import Foundation
protocol ControllerRouter {
	func route(to controllerToPresent: ViewController)
}
