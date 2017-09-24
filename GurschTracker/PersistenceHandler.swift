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
	let sessionIds = Variable<[String]>([])
	var totalAmount = Variable<Int>(0)
	private let bag = DisposeBag()

	var opponentsHandle: DatabaseHandle?

	init() {
		databaseRef = Database.database().reference()
		initializeOpponentsChildAdded()
		initializeOpponentsChildChanged()
		initializeOpponentsChildRemoved()
		//initializeSessionsChildAdded()
	}

	//MARK: - writing funs
	public func addOpponentToDatabase(_ name: String){
		self.databaseRef?.child("opponents").childByAutoId().updateChildValues(nameToDir(name))
	}

	public func addSessionToDatabase(opponentName: String, amount: Int){
		self.databaseRef?.child("sessions").childByAutoId().updateChildValues(sessionDataToDir(opponentName: opponentName, amount: amount))
	}
	//MARK: - init opponent loading funcs
	func initializeOpponentsChildAdded(){
		print("childAdded")
		let opponentsQuery = databaseRef?.child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childAdded, with: { (snapshot) in

			let name = self.opponentNameFromSnapshot(snapshot: snapshot)
			let amount = self.opponentAmountFromSnapshot(snapshot: snapshot)
			let opponent = Opponent(name: name, amount: amount, toBeWrittenToDatabase: false)
			self.opponents.value.append(opponent)

			self.totalAmount.value += opponent.amount

			print("initializeOpponentsChildAdded debug: opponents.count = \(self.opponents.value.count)")
		})
	}

	private func initializeOpponentsChildChanged() {
		print("childChanged")
		let opponentsQuery = databaseRef?.child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childChanged, with: { (snapshot) in

			let name = self.opponentNameFromSnapshot(snapshot: snapshot)
			let amount = self.opponentAmountFromSnapshot(snapshot: snapshot)
			print("Firebase detected a change to \(name), his/her new amount is: \(amount)")
			
			var oldTotalAmount = 0
			var opponentsWithoutCurrent = self.opponents.value.filter({ (opponent) -> Bool in
				if opponent.name == name {
					oldTotalAmount = opponent.amount
					return false
				}
				return true
			})
			let currentOpponent = Opponent(name: name, amount: amount, toBeWrittenToDatabase: false)
			opponentsWithoutCurrent.append(currentOpponent)
			self.opponents.value = opponentsWithoutCurrent
			
			let deltaAmount = amount - oldTotalAmount
			self.totalAmount.value += deltaAmount
			print("initializeOpponentsChildChanged debug: opponents.count = \(self.opponents.value.count)")
		})
	}

	func initializeOpponentsChildRemoved() {
		let opponentsQuery = databaseRef?.child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childRemoved, with: { (snapshot) in

			let name = self.opponentNameFromSnapshot(snapshot: snapshot)
			let amount = self.opponentAmountFromSnapshot(snapshot: snapshot)

			self.opponents.value = self.opponents.value.filter() { $0.name != name }

			self.totalAmount.value -= amount

			print("initializeOpponentsChildRemoved debug: opponents.count = \(self.opponents.value.count)")
		})
	}

	//MARK: - init session loading funcs
	private func initializeSessionsChildAdded () {

		let sessionsQuery = databaseRef?.child("sessions").queryOrdered(byChild: "opponent")
		sessionsQuery?.observe(.childAdded, with: { (snapshot) in
			let amount = self.sessionAmountFromSnapshot(snapshot: snapshot)
//			let opponentName = self.sessionNameFromSnapshot(snapshot: snapshot)
			let  date = self.sessionDateFromSnapshot(snapshot: snapshot)

			guard let session = Session(amount: amount, id: snapshot.key, date: date) else {
				return
			}
			self.sessions.value.append(session)
			print("initializeSessionsChildAdded debug: sessions.count = \(self.sessions.value)")
		})
	}

	//MARK: - private misc funcs
	private func nameToDir(_ name: String) -> [String : Any] {
		let dir: [String : Any] = ["name" : name, "amount" : 0]
		return dir
	}

	private func sessionDataToDir(opponentName: String, amount: Int) -> [String : Any]{
		let dir: [String : Any] = ["opponentName" : opponentName, "amount" : amount]
		return dir
	}
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

	private func sessionAmountFromSnapshot(snapshot: DataSnapshot) -> Int{
		guard let sessionProperties = snapshot.value as? [String : Any] else {
			print("session from database unable to cast to string : Any")
			return 0
		}
		let amount = sessionProperties["amount"] as? Int
		return amount ?? 0
	}

	private func sessionNameFromSnapshot(snapshot: DataSnapshot) -> String{
		guard let sessionProperties = snapshot.value as? [String : Any] else {
			print("session from database unable to cast to string : Any")
			return ""
		}
		guard let name = sessionProperties["opponentName"] as? String else {
			print("session name from database was undable to cast to string")
			return ""
		}
		return name
	}

	private func sessionDateFromSnapshot(snapshot: DataSnapshot) -> Date {
		guard let dateString = snapshot.value(forKey: "date") as? String  else{
			fatalError("session date from database was undable to cast to string")
		}

		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		guard let date = formatter.date(from: dateString) else {
			print("date: \(snapshot.key)'s date was unable to init")
			fatalError("session date from database was undable to cast to string")
		}
		return date
	}
}
