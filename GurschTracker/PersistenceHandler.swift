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
	let opponents = Variable<[String : Opponent]>([:])
	var totalAmount = Variable<Int>(0)
	private let bag = DisposeBag()

	var opponentsHandle: DatabaseHandle?
	var opponentDic: [String : Opponent] = [:]
	var sessionsDic: [String : Session] = [:]

	init() {
		databaseRef = Database.database().reference()
		initializeOpponentsChildAdded()
		initializeOpponentsChildChanged()
		initializeOpponentsChildRemoved()
		//		loadSessions()
	}

	//MARK: - writing funs
	public func writeToDatabase(_ name: String){
		self.databaseRef?.child("opponents").childByAutoId().updateChildValues(nameToDir(name))
	}

	//MARK: - init opponent loading funcs
	private func initializeOpponentsChildAdded(){
		print("childAdded")
		let opponentsQuery = databaseRef?.child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childAdded, with: { (snapshot) in

			let name = self.opponentNameFromSnapshot(snapshot: snapshot)
			let amount = self.opponentAmountFromSnapshot(snapshot: snapshot)
			let opponent = Opponent(name: name, amount: amount)
			self.opponents.value[name] = opponent

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

			let oldTotalAmount = self.opponents.value[name]?.amount ?? 0
			self.opponents.value[name] = Opponent(name: name, amount: amount)

			let deltaAmount = amount - oldTotalAmount
			self.totalAmount.value += deltaAmount

			print("initializeOpponentsChildChanged debug: opponents.count = \(self.opponents.value.count)")
		})
	}

	private func initializeOpponentsChildRemoved() {
		let opponentsQuery = databaseRef?.child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childRemoved, with: { (snapshot) in

			let name = self.opponentNameFromSnapshot(snapshot: snapshot)
			let amount = self.opponentAmountFromSnapshot(snapshot: snapshot)

			self.opponents.value.removeValue(forKey: name)
			self.totalAmount.value -= amount

			print("initializeOpponentsChildRemoved debug: opponents.count = \(self.opponents.value.count)")
		})
	}

	//MARK: - init session loading funcs
	private func loadSessions () {

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

	//	func initializeWritingToDatabase(){
	//		print("in")
	//		opponents.asObservable()
	//			.map { $0
	//				.filter { $0.value.toBeWrittenToDatabase }
	//
	//			}
	//			.subscribe (onNext: { value in
	//				print(value)
	//				if value.count > 0 {
	//					self.writeToDatabase(value)
	//				}
	//
	//			})
	//			.addDisposableTo(bag)
	//	}

	//MARK: - private misc funcs
	private func nameToDir(_ name: String) -> [String : Any] {
		var dir = [String : Any]()
		dir["name"] = name
		dir["amount"] = 0
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

}
