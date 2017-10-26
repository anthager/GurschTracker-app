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
	public static let state: ApplicationState = .dev

	public static var userRootNode: String {
		if state == ApplicationState.prod {
			return "usersprod"

		} else {
			return "usersdev"
		}
	}
	public static var publicUserDataNode: String {
		if state == ApplicationState.prod {
			return "public-user-data-dev"

		} else {
			return "public-user-data-prod"
		}
	}
}
