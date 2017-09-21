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
	var name: String
	var amount = 0
	var sessions = [Session]()

	init?(name: String) {
		guard !name.isEmpty else {
			print("no name were given")
			return nil
		}

		self.name = name
	}

	init(name: String, amount: Int = 0) {
		self.name = name
		self.amount = amount
	}

	init?(snapshot: DataSnapshot) {
		guard let opponentProperties = snapshot.value as? [String : Any] else {
			print("opponent from database unable to cast to string : Any")
			return nil
		}
		guard let name = opponentProperties["name"] as? String else {
			print("opponents name from database was undable to cast to string")
			return nil
		}
		self.name = name

		print("name = \(name) fetched from database")

		guard let amount = opponentProperties["amount"] as? Int else {
			print("opponents amount from database was undable to cast to Int")
			return nil
		}
		self.amount = amount
	}

	init?(name: String?, sessions: [Session]?, amount: Int){
		guard let name = name  else {
			print("no name were given")
			return nil
		}

		if let sessions = sessions {
			self.sessions = sessions
		}

		self.name = name
		self.amount = amount
	}

	public mutating func addAmount(amount: Int){
		self.amount += amount
	}

	public mutating func change(snapshot: DataSnapshot){

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
