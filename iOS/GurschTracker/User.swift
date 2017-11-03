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
	var name: String { get }
	var email: String { get }
	var uid: String { get }
}

struct User: Player {

	//MARK: - properties
	let name: String
	let email: String
	let uid: String

	init?(snapshot: DataSnapshot) {
		guard let properties = snapshot.value as? [String : Any] else {
			print("user from database unable to cast to string : Any")
			return nil
		}
		guard let uid = properties["uid"] as? String, let email = properties["email"] as? String else {
			print("unable to init user")
			return nil
		}
		self.uid = uid
		self.email = email
		self.name = ""
	}
}

