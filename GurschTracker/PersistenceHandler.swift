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

			let name = self.opponentNameFromSnapshot(snapshot: snapshot)
			let amount = self.opponentAmountFromSnapshot(snapshot: snapshot)
			let opponent = Opponent(name: name, amount: amount)
			self.opponents.value.append(opponent)

			self.totalAmount.value += opponent.amount

			print("loadOpponents debug: opponents.count = \(self.opponents.value.count)")
		})
	}

	func bindOpponentsChanged () {
		let opponentsQuery = databaseRef?.child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childChanged, with: { (snapshot) in

			let name = self.opponentNameFromSnapshot(snapshot: snapshot)
			let amount = self.opponentAmountFromSnapshot(snapshot: snapshot)

			print("Firebase detected a change to \(name), his/her new amount is: \(amount)")

			var oldValue = 0
			var opponentsWithoutCurrent = self.opponents.value.filter({ (opponent) -> Bool in
				if opponent.name == name {
					oldValue = opponent.amount
					return false
				}
				return true
			})
			let currentOpponent = Opponent(name: name, amount: amount)
			opponentsWithoutCurrent.append(currentOpponent)
			self.opponents.value = opponentsWithoutCurrent

			let deltaAmount = amount - oldValue
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

	//MARK: - private funcs
	private func opponentNameFromSnapshot(snapshot: DataSnapshot) -> String{
		guard let opponentProperties = snapshot.value as? [String : Any] else {
			print("opponent from database unable to cast to string : Any")
			return ""
		}
		guard let name = opponentProperties["name"] as? String else {
			print("opponents name from database was undable to cast to string")
			return ""
		}
		return name
	}

	private func opponentAmountFromSnapshot(snapshot: DataSnapshot) -> Int{
		guard let opponentProperties = snapshot.value as? [String : Any] else {
			print("opponent from database unable to cast to string : Any")
			return 0
		}

		let amount = opponentProperties["amount"] as? Int
		return amount ?? 0
	}

}
