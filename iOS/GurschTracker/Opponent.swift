//
//  Opponent.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-06.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import FirebaseDatabase
import Foundation

struct Opponent: Player {

	//MARK: properites
	//Remove "" and make var
	let name: String
	var amount = 0
	var toBeWrittenToDatabase: Bool = false
	var sessions = [Session]()
	let uid: String
	let email: String

	//after since there is alot of changing in how the opponent system works, its esier to make a identifier that can be changed to name later if that would be more suitable

	init?(snapshot: DataSnapshot) {
		guard let properties = snapshot.value as? [String : Any] else {
			print("opponent from database unable to cast to string : Any, \(snapshot)")
			return nil
		}
		guard let uid = properties["uid"] as? String, let amount = properties["amount"] as? Int else {
			print("unable to init opponent, \(snapshot)")
			return nil
		}

		self.uid = uid
		self.amount = amount
		self.email = properties["email"] as? String ?? ""
		self.name = properties["name"] as? String ?? ""
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
