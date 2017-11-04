//
//  viewModel.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-09-17.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

//all the apps data, not sure if this is the right way to do mvvm

import Foundation
import RxSwift

class ViewModel {

	//MARK: - properties

	//MARK: - Rx props
	private let _sessions: Variable<[String : Session]>
	private let _opponents: Variable<[String : Opponent]>
	private let _users: Variable<[String : User]>
	private let _totalAmount: Variable<Int>

	//MARK: - misc props
	private let persistenceHandler: PersistenceHandler

	//MARK: - public props
//	public var opponents: Observable<[Opponent]> {
//		return _opponents.asObservable()
//	}
	public var opponents: Observable<[String : Opponent]> {
		return _opponents.asObservable()
	}

	public var sessions: Observable<[String : Session]> {
		return _sessions.asObservable()
	}

	public var totalAmount: Observable<Int> {
		return _totalAmount.asObservable()
	}

	public var users: Observable<[String : User]> {
		return _users.asObservable()
	}

	//MARK: inits
	public init(){
		persistenceHandler = PersistenceHandler()
		_sessions = persistenceHandler.sessions
		_opponents = persistenceHandler.opponents
		_totalAmount = persistenceHandler.totalAmount
		_users = persistenceHandler.users
	}

	//MARK: - funcs for editing from view

	public func addSession(opponent: String, sessionAmount: Int){
		for _opponent in _opponents.value {
			if _opponent.value.identifier == opponent {
				let session = Session(amount: sessionAmount, opponent: _opponent.value)
				persistenceHandler.addSessionToDatabase(session: session)
			} else {
				print("bug in viewModel, no key for that value")
			}
		}
	}
}


