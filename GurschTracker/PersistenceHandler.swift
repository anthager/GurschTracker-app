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

//give when loading, the function takes an array of the type it will load and async keeps this array up to date
import Foundation
import Firebase
//currently using firebase
class PersistenceHandler {

	//MARK: - properties
	var databaseRef: DatabaseReference?
	var databaseHandle: DatabaseHandle?
	private var opponents_: [Opponent]
	private var sessions_: [Session]
	var opponentsHandle: DatabaseHandle?
	var opponentDic: [String : Opponent] = [:]
	var sessionsDic: [String : Session] = [:]

	var sessions: [Session] {
		get {
			return sessions_
		}
	}

	var opponents: [Opponent] {
		get {
			return opponents_
		}
	}

//	//singleton
//	static let shared = PersistenceHandler()
//
//	private init () {
//		databaseRef = Database.database().reference()
//	}

	init(opponents: [Opponent], sessions: [Session]) {
		self.opponents_ = opponents
		self.sessions_ = sessions
		databaseRef = Database.database().reference()
	}

	//It doesnt matter if the two funcs is async, just let them load thier shit for now since you only will display the total amount on the start page 

	func loadOpponents (){

		let opponentsQuery = databaseRef?.child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childAdded, with: { (snapshot) in
			//May go a level to deep

			print("Inside")

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
//			guard let sessionsDic = opponentProperties["sessions"] as? [String : Bool] else {
//				return
//			}
//			var sessions: [Session] = []
//			for session in sessionsDic {
//				sessions.append(session)
//			}
			guard let opponent = Opponent(name: name, sessions: nil, amount: amount) else {
				print("unable to make opponent from name and amount ")
				return
			}

			self.opponents_.append(opponent)
			self.opponentDic["name"] = opponent
		})

		print("Oppoenents loaded successfully")

	}

	//TODO: Will get problem with fucking async shit as always

	func loadSessions () {

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

//			guard let opponentString = snapshot.value(forKey: "opponent") as? String else {
//				print("opponent: \(snapshot.key)'s amount was unable to init")
//				return
//			}
//
//			guard let opponent = self.opponentDic[opponentString] else {
//				print("opponent didn't exist")
//				return
//			}
//
//			guard let session = Session(amount: amount, id: snapshot.key, date: date, opponent: opponent) else {
//				return
//			}

			guard let session = Session(amount: amount, id: snapshot.key, date: date) else {
				return
			}
			self.sessions_.append(session)

		})
	}




}
