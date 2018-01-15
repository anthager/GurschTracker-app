//
//  User.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-10-26.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol Player {
	var email: String { get }
	var uid: String { get }
}

extension Player {
	var identifier: String {
		if email != "" {
			return email
		} else {
			return uid
		}
	}
}

struct GUser: Player {

	//MARK: - properties
	let email: String
	let uid: String

	init?(snapshot: DataSnapshot) {
		guard let properties = snapshot.value as? [String : Any] else {
			print("user from database unable to cast to string : Any")
			return nil
		}
		let uid = snapshot.key
		guard let email = properties["email"] as? String else {
			print("unable to init user")
			return nil
		}
		self.uid = uid
		self.email = email
	}
}

