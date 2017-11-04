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
	let users = Variable<[String : User]>([:])
	var totalAmount = Variable<Int>(0)
	private let bag = DisposeBag()

	var opponentsHandle: DatabaseHandle?

	init() {
		self.databaseRef = Database.database().reference()
		self.initializeUserListener()
		DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
			self.initializeUserValue()
		})
		DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(2000), execute: {
			self.initializeOpponentsChildAdded()
			self.initializeOpponentsChildChanged()
			self.initializeOpponentsChildRemoved()
		})
	}

	private func initializeUserListener(){
		authHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
			self.uid = user?.uid
			print("new user logged in with uid: \(user?.uid ?? "no uid") and email: \(user?.email ?? "no email")")
		}
	}

	//MARK: - writing funs

	public func addSessionToDatabase(session: Session){

		guard let uid = self.uid else {
			print("no uid in pers. hand.")
			return
		}
		//fix this unwrapped
		//users is mapped with their id not email
		let parameters: [String: Any] = ["user": uid, "opponent": session.opponent.uid, "amount": session.amount]
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
		print("users changed")
		let usersQuery = databaseRef?.child(CurrentApplicationState.publicUserDataRoot).queryOrdered(byChild: "email")
		_ = usersQuery?.observe(.childAdded, with: { (snapshot) in
			guard let user = User(snapshot: snapshot) else {
				print("init of \(snapshot) failed ")
				return
			}
			if user.name == "" {
				self.users.value[user.uid] = user
				print("\(user) inited")
			} else {
				self.users.value[user.name] = user
				print("\(user) inited")
			}

		})
	}
	//need to fix the user changed and user deleted methods as well see issue #12
	//MARK: - init user loading funcs
	private func initializeOpponentsChildAdded(){
		print("childAdded")
		guard let uid = self.uid else {
			print("no uid")
			return
		}
		let opponentsQuery = databaseRef?.child(CurrentApplicationState.privateUserDataRoot).child(uid).child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childAdded, with: { (snapshot) in

			guard let opponent = Opponent(snapshot: snapshot) else {
				return
			}
			self.opponents.value[opponent.uid] = opponent

			self.totalAmount.value += opponent.amount

			print("initializeOpponentsChildAdded debug: opponents.count = \(self.opponents.value.count)")
		})
	}
	//MARK: - init opponent loading funcs
	//TODO: bug somewhere here, when a session is added the amount of the session is the new total for that opponent. The same with the totalAmount
	private func initializeOpponentsChildChanged() {
		print("childChanged")
		guard let uid = self.uid else {
			print("no uid")
			return
		}
		let opponentsQuery = databaseRef?.child(CurrentApplicationState.privateUserDataRoot).child(uid).child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childChanged, with: { (snapshot) in

			guard let opponent = Opponent(snapshot: snapshot) else {
				return
			}

			let oldTotalAmount = self.opponents.value[opponent.identifier]?.amount ?? 0
			self.opponents.value[opponent.uid] = opponent

			let deltaAmount = opponent.amount - oldTotalAmount
			self.totalAmount.value += deltaAmount

			print("initializeOpponentsChildChanged debug: opponents.count = \(self.opponents.value.count)")
		})
	}

	private func initializeOpponentsChildRemoved() {
		guard let uid = self.uid else {
			print("no uid")
			return
		}
		let opponentsQuery = databaseRef?.child(CurrentApplicationState.privateUserDataRoot).child(uid).child("opponents").queryOrdered(byChild: "amount")
		opponentsHandle = opponentsQuery?.observe(.childRemoved, with: { (snapshot) in

			guard let opponent = Opponent(snapshot: snapshot) else {
				return
			}

			self.opponents.value.removeValue(forKey: opponent.uid)
			self.totalAmount.value -= opponent.amount

			print("initializeOpponentsChildRemoved debug: opponents.count = \(self.opponents.value.count)")
		})
	}

	//MARK: - init session loading funcs
	private func initializeSessionsChildAdded () {
		guard let uid = self.uid else {
			print("no uid")
			return
		}
		let sessionsQuery = databaseRef?.child(CurrentApplicationState.privateUserDataRoot).child(uid).child("sessions").queryOrdered(byChild: "opponent")
		sessionsQuery?.observe(.childAdded, with: { (snapshot) in
			print(snapshot)
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
}
