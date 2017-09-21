//
//  PersistenceHandler.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-09-03.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

// This service class should handle the persitence of the model in a smart way to keep the architecture nice.

import Foundation
import Firebase
import RxSwift

//currently using firebase
class PersistenceHandler {

	//MARK: - properties
	var databaseRef: DatabaseReference?
	var databaseHandle: DatabaseHandle?

	//Rx props
	let sessions = Variable<[Session]>([])
	let opponents = Variable<[Opponent]>([])
	var totalAmount = Variable<Int>(0)
	private let bag = DisposeBag()

	var opponentsHandle: DatabaseHandle?
	var opponentDic: [String : Opponent] = [:]
	var sessionsDic: [String : Session] = [:]

	init() {
		databaseRef = Database.database().reference()
		loadOpponents()
		bindOpponentsChanged()

//		loadSessions()
	}


	//It doesnt matter if the two funcs is async, just let them load thier shit for now since you only will display the total amount on the start page 

	func loadOpponents (){
		let opponentsQuery = databaseRef?.child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childAdded, with: { (snapshot) in

			guard let opponentProperties = snapshot.value as? [String : Any] else {
				print("opponent from database unable to cast to string : Any")
				return
			}
			guard let name = opponentProperties["name"] as? String else {
				print("opponents name from database was undable to cast to string")
				return
			}
			print("name = \(name) fetched from database")

			guard let amount = opponentProperties["amount"] as? Int else {
				print("opponents amount from database was undable to cast to Int")
				return
			}
			print("amount = \(amount) fetched from database")

			self.totalAmount.value += amount

			guard let opponent = Opponent(name: name, sessions: nil, amount: amount) else {
				print("unable to make opponent with name: \(name) and amount: \(amount) ")
				return
			}

			self.opponents.value.append(opponent)

			print("loadOpponents debug: opponents.count = \(self.opponents.value.count)")
		})
	}

	func bindOpponentsChanged () {
		let opponentsQuery = databaseRef?.child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childChanged, with: { (snapshot) in

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
			print("Firebase detected a change to \(name), his/her new amount is: \(amount)")

			guard let opponent = self.opponents.value.first(where: { (opponent) -> Bool in
				return opponent.name == name
			}) else {
				print("changed opponent not found in array")
				return
			}

			let deltaAmount = amount - opponent.amount
			self.totalAmount.value += deltaAmount

			print("loadOpponents debug: opponents.count = \(self.opponents.value.count)")
		})

	}

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
			self.sessions.value.append(session)

		})
	}

}
