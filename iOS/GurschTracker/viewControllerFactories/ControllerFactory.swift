//
//  ControllerFactory.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-16.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import Foundation
protocol ControllerFactory {
	func build() -> ViewController
}
