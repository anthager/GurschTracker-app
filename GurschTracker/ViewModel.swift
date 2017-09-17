//
//  viewModel.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-09-17.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

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
		guard let opponent = Opponent(name: name) else {
			print("bug: opponent was unable to be init from name only init, things is seriously fucked up")
			return
		}
		_opponents.value.append(opponent)
	}

	//MARK: - func for amount

//	func addToTotalAmount(_ amount: Int) {
//		if _totalAmount == nil {
//			calculateTotalAmount()
//		}
//		_totalAmount! += amount
//	}

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


