//
//  TimeSettingHandler.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-23.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import Foundation

public class TimeSettingHandler {

	//singleton
	static let shared = TimeSettingHandler()

	private init () {
		timeSetting = today
	}

	private let calender = Calendar.current

	private let today = Date()
	private let sevenDaysAgo = Date(timeIntervalSinceNow: -604800)
	private let thirtyDaysAgo = Date(timeIntervalSinceNow: -2592000)
	private let allTime = Date(timeIntervalSince1970: 0)

	private var timeSetting: Date

	var allOpponents: [Opponent]?

	var amounts: [Opponent: Int]? {
		get {
			guard let safeOpponents = opponents else {
				return nil
			}

			guard let safeOpponentSessions = opponentSessions else {
				return nil
			}

			var amountsInTimeInterval = [Opponent: Int]()
			for opponent in safeOpponents {
				guard let safeOpponentSessions = safeOpponentSessions[opponent] else {
					fatalError("\(opponent.name) is in the opponentList for the given timeInterval but the directory didn't have any sessions, bug")
				}

				var opponentAmountInTimeInterval = 0
				for session in safeOpponentSessions {
					opponentAmountInTimeInterval += session.amount
				}

				amountsInTimeInterval[opponent] = opponentAmountInTimeInterval
			}

			return amountsInTimeInterval
		}
	}

	var opponentSessions: [Opponent: [Session]]? {
		get {
			guard let safeOpponents = opponents else {
				return nil
			}

			var opponentSessionsInTimeInterval: [Opponent: [Session]]?

			for opponent in safeOpponents {
				var opponentSessions: [Session]?

				//print("opponent.session = \(opponent.sessions.count)")
				for session in opponent.sessions {
					//print(session.date > timeSetting)
					if calender.isDate(session.date, inSameDayAs: timeSetting) || session.date > timeSetting {

						if opponentSessions == nil {
							opponentSessions = [Session]()
						}
						opponentSessions?.append(session)
					}
				}

				if opponentSessions == nil {
					continue
				}

				if opponentSessionsInTimeInterval == nil {
					opponentSessionsInTimeInterval = [Opponent: [Session]]()
				}
				opponentSessionsInTimeInterval?[opponent] = opponentSessions


			}
			return opponentSessionsInTimeInterval
		}
	}

	var sessions: [Session]? {
		get {
			guard let safeOpponents = opponents else {
				return nil
			}

			guard let safeOpponentSessions = opponentSessions else {
				return nil
			}

			var sessionsInTimeInterval = [Session]()

			for opponent in safeOpponents {
				guard let safeSequence: [Session] = safeOpponentSessions[opponent] else {
					continue
				}
				sessionsInTimeInterval.append(contentsOf: safeSequence)
			}
			return sessionsInTimeInterval
		}
	}

	var opponents: [Opponent]? {
		get {
			guard let allOpponents = TimeSettingHandler.shared.allOpponents else {
				return nil
			}

			if allOpponents.count == 0 {
				return nil
			}

			var opponentsInTimeInteral: [Opponent]?
			for opponent in allOpponents {

				if let safeDate = opponent.sessions.last?.date, calender.isDate(safeDate, inSameDayAs: timeSetting) || safeDate > timeSetting {

					if opponentsInTimeInteral == nil {
						opponentsInTimeInteral = [Opponent]()
					}
					
					opponentsInTimeInteral?.append(opponent)
				}
			}
			return opponentsInTimeInteral
		}
	}

	var totalAmount: Int {
		get {
			guard let safeOpponents = opponents else {
				return 0
			}

			guard let safeAmountDir = amounts else {
				return 0
			}

			var totalAmountInTimeInterval = 0

			for opponent in safeOpponents {
				guard let safeOpponentAmount = safeAmountDir[opponent] else {
					fatalError("\(opponent.name) didn't have an amount attached")
				}

				totalAmountInTimeInterval += safeOpponentAmount
			}
			return totalAmountInTimeInterval
		}
	}

	public func setToday(){
		timeSetting = today
	}
	public func setSevenDays(){
		timeSetting = sevenDaysAgo
	}
	public func setThirtyDays(){
		timeSetting = thirtyDaysAgo
	}
	public func setAllTime(){
		timeSetting = allTime
	}
}
