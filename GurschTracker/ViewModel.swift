//
//  viewModel.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-09-17.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

//Istead of having a array with new values, have just a variable that starts a async write to db

import Foundation
import RxSwift

class ViewModel {

	//MARK: - properties

	//MARK: - Rx props
	private let _sessions: Variable<[Session]>
	private let _opponents: Variable<[Opponent]>
	private let _totalAmount: Variable<Int>

	//MARK: - misc props
	private let persistenceHandler: PersistenceHandler

	//MARK: - public props
	public var opponents: Observable<[Opponent]> {
		return _opponents.asObservable()
	}

	public var sessions: Observable<[Session]> {
		return _sessions.asObservable()
	}

	public var totalAmount: Observable<Int> {
		return _totalAmount.asObservable()
	}

	//MARK: inits
	public init(){
		persistenceHandler = PersistenceHandler()
		_sessions = persistenceHandler.sessions
		_opponents = persistenceHandler.opponents
		_totalAmount = persistenceHandler.totalAmount
	}

	//MARK: - funcs for editing from view
	public func newOpponent(_ name: String){
		persistenceHandler.addOpponentToDatabase(name)
	}

	public func addSession(opponentName: String, amount: Int ){
		persistenceHandler.addSessionToDatabase(opponentName: opponentName, amount: amount)
	}

	//MARK: - funcs for opponents
	func getAllSessions(opponents: [Opponent]) -> [Session] {
		var sessions = [Session]()
		for opponent in opponents {
			for session in opponent.sessions {
				sessions.append(session)
			}
		}

		return sessions
	}

	func resetOpponents() {
		//		opponents.value = [Opponent]()
	}


	//	func setupSampleOpponents(){
	//
	//		guard let opponent1 = Opponent(name: "Peter") else {
	//			fatalError("Unable to instantiate opponent1")
	//		}
	//		guard let opponent2 = Opponent(name: "Adam") else {
	//			fatalError("Unable to instantiate opponent2")
	//		}
	//		guard let opponent3 = Opponent(name: "Petronella") else {
	//			fatalError("Unable to instantiate opponent3")
	//		}
	//
	//		opponents += [opponent1, opponent2, opponent3]
	//	}


	//MARK: - private funcs

}


