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

	let sessions: Variable<[Session]>
	let opponents: Variable<[Opponent]>
	let persistenceHandler: PersistenceHandler

	var totalAmount = 0

	init(){
		persistenceHandler = PersistenceHandler()
		sessions = persistenceHandler.sessions
		opponents = persistenceHandler.opponents
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

//	func reset(){
//		resetOpponents()
////		_totalAmount = nil
//	}

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

//	private func calculateTotalAmount(){
//		var amount = 0
//
//		for opponent in opponents.value {
//			amount += opponent.amount
//		}
//		_totalAmount = amount
//	}

}


