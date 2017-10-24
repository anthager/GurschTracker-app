//
//  Session.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-06.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Session {

	//MARK: - properties
	let amount: Int
	let id: String
	let date: Date

	init(amount: Int, id: String) {
		self.amount = amount
		self.id = id
		date = Date()
	}

	init(amount: Int, date: Date, id: String){
		self.amount = amount
		self.id = id
		self.date = date
	}

	//MARK: - static test case

//	static func testSetup() -> [Session]{
//		let sessions = [Session(amount:10 , id: 0, date: Date(timeIntervalSinceNow: -2600000))!,
//		                Session(amount:10 , id: 0, date: Date(timeIntervalSinceNow: -2590000))!,
//		                Session(amount:10 , id: 0, date: Date(timeIntervalSinceNow: -600800))!,
//		                Session(amount:10 , id: 0, date: Date(timeIntervalSinceNow: -2000))!,
//		                Session(amount: 10, id: 1, date: Date())!]
//		return sessions
//	}
}
