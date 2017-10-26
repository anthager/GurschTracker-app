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
	var authHandler: AuthStateDidChangeListenerHandle?
	var uid: String?
	//var authHandle:

	//Rx props
	let sessions = Variable<[String : Session]>([:])
	let opponents = Variable<[String : Opponent]>([:])
	let sessionIds = Variable<[String]>([])
	let users = Variable<[String : Session]>([:])
	var totalAmount = Variable<Int>(0)
	private let bag = DisposeBag()

	var opponentsHandle: DatabaseHandle?

	init() {
		databaseRef = Database.database().reference()
		initializeOpponentsChildAdded()
		initializeOpponentsChildChanged()
		initializeOpponentsChildRemoved()
		initializeUserListener()

		//initializeSessionsChildAdded()
		//		initializeTotalAmount()
	}

	private func initializeUserListener(){
		authHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
			self.uid = user?.uid
			print("new user logged in with uid: \(user?.uid ?? "no uid") and email: \(user?.email ?? "no email")")
		}
	}

	//MARK: - writing funs

	public func addSessionToDatabase(opponentName: String, amount: Int){

		guard let uid = self.uid else {
			print("no uid in pers. hand.")
			return
		}

		let parameters: [String: Any] = ["user": "qlgkY2zTzudkB5sqEsiROuLYiOn2", "opponent": "RNdxAOtFYQaEO2popo8z9wQAjw23", "amount": amount]
		print(parameters)
		let path = "https://us-central1-gurschtracker.cloudfunctions.net/addSession"
		var request = URLRequest(url: URL(string: path)!)

		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
			print("making json of the parameters in postToApi failed")
			return
		}
		request.httpBody = httpBody
		let session = URLSession.shared
		session.dataTask(with: request) { (data, response, error) in
			if error != nil {
				print("http request failed with \(String(describing: error))")
				return
			}
			if let response = response {
				print(response)
			}
			if let data = data {
				do {
					let json = try JSONSerialization.jsonObject(with: data, options: [])
					print(json)
				}
				catch {
					print(error)
				}
			}
			}.resume()
	}

	private func initializeUserValue(){

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

			self.totalAmount.value += amount

			print("initializeOpponentsChildAdded debug: opponents.count = \(self.opponents.value.count)")
		})
	}
	//TODO: bug somewhere here, when a session is added the amount of the session is the new total for that opponent. The same with the totalAmount
	private func initializeOpponentsChildChanged() {
		print("childChanged")
		let opponentsQuery = databaseRef?.child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childChanged, with: { (snapshot) in

			let name = self.opponentNameFromSnapshot(snapshot: snapshot)
			let newAmount = self.opponentAmountFromSnapshot(snapshot: snapshot)
			print("Firebase detected a change to \(name), his/her new amount is: \(newAmount)")

			let oldTotalAmount = self.opponents.value[name]?.amount ?? 0
			self.opponents.value[name] = Opponent(name: name, amount: newAmount)

			let deltaAmount = newAmount - oldTotalAmount
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
	private func initializeSessionsChildAdded () {

		let sessionsQuery = databaseRef?.child("sessions").queryOrdered(byChild: "opponent")
		sessionsQuery?.observe(.childAdded, with: { (snapshot) in
			let amount = self.sessionAmountFromSnapshot(snapshot: snapshot)
			//			let opponentName = self.sessionNameFromSnapshot(snapshot: snapshot)
			let  date = self.sessionDateFromSnapshot(snapshot: snapshot)

			let session = Session(amount: amount, date: date, id: snapshot.key)
			self.sessions.value[snapshot.key] = session
			print("initializeSessionsChildAdded debug: sessions.count = \(self.sessions.value)")
		})
	}

	//MARK: - private misc funcs
	private func opponentDataToDir(name: String, amount: Int) -> [String : Any] {
		let dir: [String : Any] = ["name" : name, "amount" : amount]
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
