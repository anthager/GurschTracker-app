//
//  PersistenceHandler.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-09-03.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import Foundation
import Firebase
//currently using firebase
class PersistenceHandler {

	//MARK: - properties
	var databaseRef: DatabaseReference?
	var databaseHandle: DatabaseHandle?
	var opponents = [Opponent]()
	var sessions: [Session]?
	var opponentsHandle: DatabaseHandle?

	//singleton
	static let shared = PersistenceHandler()

	private init () {
		databaseRef = Database.database().reference()
	}

	func loadOpponents () -> [Opponent]?{

		let opponentsQuery = databaseRef?.child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.value, with: { (snapshot) in
			guard let opponentProperties = snapshot.value as? [String : Any] else {
				print("opponent from database unable to cast to string : Any")
				return
			}
			guard let name = opponentProperties["name"] as? String else {
				print("opponents name from database was undable to cast to string")
				return
			}
			guard let amount = opponentProperties["amount"] as? Int else {
				print("opponents amount from database was undable to cast to Int")
				return
			}
//			guard let sessions = opponentProperties["sessions"] as? [String : Boolean] else {
//				return
//			}
			guard let opponent = Opponent(name: name, sessions: nil, amount: amount) else {
				print("unable to make opponent from name and amount ")
				return
			}

			opponents.append(opponent)
		})

		if opponents.count > 0 {
			return opponents
		}
		else {
			return nil
		}
	}

	func loadSessions () -> [Session] {
		var sess
	}


}
