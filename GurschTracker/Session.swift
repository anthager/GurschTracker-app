//
//  Session.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-06.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import Foundation

class Session: NSObject, NSCoding{

	//MARK: - properties
	static var idCount = 0
	let amount: Int
	let id: Int
	let date: Date

	init(amount: Int) {
		self.amount = amount
		id = Session.idCount
		Session.idCount += 1
		date = Date()
	}

	private init?(amount: Int, id: Int, date: Date) {
		self.amount = amount
		self.id = id
		self.date = date
		Session.idCount += 1
	}

	//MARK: - NSCoding
	func encode(with aCoder: NSCoder) {
		aCoder.encode(amount, forKey: SessionPropKey.amount)
		aCoder.encode(id, forKey: SessionPropKey.id)
		aCoder.encode(date, forKey: SessionPropKey.date)
	}

	required convenience init?(coder aDecoder: NSCoder) {
		let amount = aDecoder.decodeInteger(forKey: SessionPropKey.amount)
		let id = aDecoder.decodeInteger(forKey: SessionPropKey.id)
		guard let date = aDecoder.decodeObject(forKey: SessionPropKey.date) as? Date else { fatalError("No date found") }

		self.init(amount: amount, id: id, date: date)
	}

	//MARK: - static test case

	static func testSetup() -> [Session]{
		let sessions = [Session(amount:10 , id: 0, date: Date(timeIntervalSinceNow: -2600000))!,
		                Session(amount:10 , id: 0, date: Date(timeIntervalSinceNow: -2590000))!,
		                Session(amount:10 , id: 0, date: Date(timeIntervalSinceNow: -600800))!,
		                Session(amount:10 , id: 0, date: Date(timeIntervalSinceNow: -2000))!,
		                Session(amount: 10, id: 1, date: Date())!]
		return sessions
	}

}


struct SessionPropKey {
	static let amount = "amount"
	static let id = "id"
	static let date = "date"
}
