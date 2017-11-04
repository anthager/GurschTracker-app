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

enum CurrentApplicationState {
	public static let state: ApplicationState = .prod

	public static var privateUserDataRoot: String {
		if state == ApplicationState.prod {
			return "private-user-data-prod"

		} else {
			return "usersdev"
		}
	}
	public static var publicUserDataRoot: String {
		if state == ApplicationState.dev {
			return "public-user-data-dev"

		} else {
			return "public-user-data-prod"
		}
	}
}
