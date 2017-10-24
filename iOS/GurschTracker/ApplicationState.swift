//
//  ApplicationState.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-10-24.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import Foundation
//simply for making it easier for switching between dev and production and making both states easier
enum ApplicationState {
	case dev
	case prod
}

struct CurrentApplicationState {
	public static let state: ApplicationState = .dev
}
