//
//  Opponent.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-06.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import Foundation

class Opponent: NSObject, NSCoding{

	//MARK: properites
	var name: String
	var amount = 0

	init?(name: String) {
		guard !name.isEmpty else {
			print("no name were given")
			return nil
		}

		self.name = name
	}

	private init?(name: String?, amount: Int){
		guard let safeName = name  else {
			print("no name were given")
			return nil
		}

		self.name = safeName
		self.amount = amount
	}

	public func addAmount(amount: Int){
		self.amount += amount
	}

	//MARK: - NSCoding
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: OpponentPropKey.name)
		aCoder.encode(amount, forKey: OpponentPropKey.amount)
	}

	required convenience init?(coder aDecoder: NSCoder) {
		let name = aDecoder.decodeObject(forKey: OpponentPropKey.name) as? String

		let amount = aDecoder.decodeInteger(forKey: OpponentPropKey.amount)

		self.init(name: name, amount: amount)
	}

	//MARK: - Archiving Paths
	static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
	static let ArchiveURL = DocumentsDirectory.appendingPathComponent("opponents")

}

//MARK: - keys
struct OpponentPropKey {
	static let name = "name"
	static let amount = "amount"
}
