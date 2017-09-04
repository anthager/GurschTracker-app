//
//  PersistenceHandler.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-09-03.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

// This service class should handle the persitence of the model in a smart way to keep the architecture nice.
// The goal in a later iteration is to make this some kind of generic smart 
// engeenering thing that takes a list in its init and updates it async.
import Foundation
import Firebase
//currently using firebase
class PersistenceHandler {

	//MARK: - properties
	var databaseRef: DatabaseReference?
	var databaseHandle: DatabaseHandle?
	var opponents: [Opponent] = []
	var sessions: [Session] = []
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

			self.opponents.append(opponent)
		})

		if opponents.count > 0 {
			return opponents
		}
		else {
			return nil
		}

	}

	func loadSessions () -> [Session] {

		let sessionsQuery = databaseRef?.child("sessions").queryOrdered(byChild: "opponent")
		sessionsQuery?.observe(.childAdded, with: { (snapshot) in
			guard let amount = snapshot.value(forKey: "amount") as? Int else {
				print("session: \(snapshot.key)'s amount was unable to init")
				return
			}
			guard let dateString = snapshot.value(forKey: "date") as? String  else{
				print("date: \(snapshot.key)'s date was unable to init")
				return
			}

			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
			guard let date = formatter.date(from: dateString) else {
				print("date: \(snapshot.key)'s date was unable to init")
				return
			}

			guard let opponentString = snapshot.value(forKey: "opponent") as? String else {
				print("opponent: \(snapshot.key)'s amount was unable to init")
				return
			}

			
		})
	}


}
