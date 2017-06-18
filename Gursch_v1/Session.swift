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
	let opponent: Opponent
	let amount: Int
	let id: Int
	let date = Date()

	init(opponent: Opponent, amount: Int) {
		self.opponent = opponent
		self.amount = amount
		id = Session.idCount
		Session.idCount += 1
	}

	private init?(opponent: Opponent?, amount: Int, id: Int) {
		guard let safeOpponent = opponent else {
			return nil
		}
		self.opponent = safeOpponent
		self.amount = amount
		self.id = id
		Session.idCount += 1
	}

	//MARK: - NSCoding
	func encode(with aCoder: NSCoder) {
		aCoder.encode(opponent, forKey: SessionPropKey.opponent)
		aCoder.encode(amount, forKey: SessionPropKey.amount)
		aCoder.encode(id, forKey: SessionPropKey.id)
	}

	required convenience init?(coder aDecoder: NSCoder) {
		let opponent = aDecoder.decodeObject(forKey: SessionPropKey.opponent) as? Opponent

		let amount = aDecoder.decodeInteger(forKey: SessionPropKey.amount)
		let id = aDecoder.decodeInteger(forKey: SessionPropKey.id)

		self.init(opponent: opponent, amount: amount, id: id)
	}

	//MARK: - Archiving Paths
	static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
	static let ArchiveURL = DocumentsDirectory.appendingPathComponent("sessions")

}


struct SessionPropKey {
	static let opponent = "opponent"
	static let amount = "amount"
	static let id = "id"
}
