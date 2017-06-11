//
//  Session.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-06.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import Foundation

class Session{

	static var idCount = 0
	let opponent: Opponent
	let amount: Int
	let id: Int

	init(opponent: Opponent, amount: Int) {
		self.opponent = opponent
		self.amount = amount
		id = Session.idCount
		Session.idCount += 1
	}
}
