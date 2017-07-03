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
	var sessions = [Session]()

	init?(name: String) {
		guard !name.isEmpty else {
			print("no name were given")
			return nil
		}

		self.name = name
	}

	private init?(name: String?, sessions: [Session]?,amount: Int){
		guard let safeName = name  else {
			print("no name were given")
			return nil
		}

		if let safeSessions = sessions {
			self.sessions = safeSessions
		}

		self.name = safeName
		self.amount = amount
	}

	public func addAmount(amount: Int){
		self.amount += amount
	}

	public func addSession(session: Session){
		sessions.append(session)
	}

	//FIXME: maybe error here
	//MARK: - NSCoding
	public func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: OpponentPropKey.name)
		aCoder.encode(amount, forKey: OpponentPropKey.amount)
		aCoder.encode(sessions, forKey: OpponentPropKey.sessions)
	}

	required convenience public init?(coder aDecoder: NSCoder) {
		let name = aDecoder.decodeObject(forKey: OpponentPropKey.name) as? String

		let sessions = aDecoder.decodeObject(forKey: OpponentPropKey.sessions) as! [Session]

		let amount = aDecoder.decodeInteger(forKey: OpponentPropKey.amount)

		self.init(name: name, sessions: sessions, amount: amount)
	}

	//MARK: - Archiving Paths
	static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
	static let ArchiveURL = DocumentsDirectory.appendingPathComponent("opponents")

	//MARK: - Private Methods


	//MARK: - static test case

	static func testSetup() -> [Opponent]{
		let opponents: [Opponent] = [
			Opponent(name: "Peter", sessions: Session.testSetup(), amount: 20)!,
			Opponent(name: "Petrina", sessions: Session.testSetup(), amount: -20)!,
			Opponent(name: "Niklas", sessions: nil, amount: 20)!]

		return opponents

	}
}

	//MARK: - keys
struct OpponentPropKey {
		static let name = "name"
		static let amount = "amount"
		static let sessions = "sessions"
}
