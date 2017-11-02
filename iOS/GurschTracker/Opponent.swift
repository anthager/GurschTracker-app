//
//  Opponent.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-06.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import FirebaseDatabase
import Foundation

struct Opponent {

	//MARK: properites
	//Remove "" and make var
	var name: String = ""
	var amount = 0
	var toBeWrittenToDatabase: Bool = false
	var sessions = [Session]()
	var uid: String = ""
	var email: String = ""

	//after since there is alot of changing in how the opponent system works, its esier to make a identifier that can be changed to name later if that would be more suitable
	var identifier: String {
		return email
		fatalError("opponent didn't have identifier. You fucked up mate")
	}

	init?(name: String) {
		guard !name.isEmpty else {
			print("no name were given")
			return nil
		}

		self.name = name
		self.toBeWrittenToDatabase = false
	}

	init(name: String, amount: Int = 0) {
		self.name = name
		self.amount = amount
		self.toBeWrittenToDatabase = true
	}

	init(name: String, amount: Int = 0, toBeWrittenToDatabase: Bool) {
		self.name = name
		self.amount = amount
		self.toBeWrittenToDatabase = toBeWrittenToDatabase
	}

	init?(snapshot: DataSnapshot) {
		guard let properties = snapshot.value as? [String : Any] else {
			print("opponent from database unable to cast to string : Any, \(snapshot)")
			return nil
		}
		guard let uid = properties["uid"] as? String, let amount = properties["amount"] as? Int, let email = properties["email"] as? String else {
			print("unable to init opponent, \(snapshot)")
			return nil
		}
		self.uid = uid
		self.amount = amount
		self.email = email
	}

	public mutating func addAmount(amount: Int){
		self.amount += amount
	}

	//MARK: - Private Methods


	//MARK: - static test case

	//	static func testSetup() -> [Opponent]{
	//		let opponents: [Opponent] = [
	//			Opponent(name: "Peter", sessions: Session.testSetup(), amount: 20)!,
	//			Opponent(name: "Petrina", sessions: Session.testSetup(), amount: -20)!,
	//			Opponent(name: "Niklas", sessions: nil, amount: 20)!]
	//
	//		return opponents
	//
	//	}
}
