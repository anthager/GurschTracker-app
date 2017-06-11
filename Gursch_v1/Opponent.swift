//
//  Opponent.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-06.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import Foundation

class Opponent{

	let name: String
	var amount = 0

	init?(name: String) {
		guard !name.isEmpty else {
			print("no name were given")
			return nil
		}

		self.name = name
	}

	public func lost(amountLost: Int){
		amount = amount - amountLost
	}

	public func won(amountWon: Int){
		amount = amount + amountWon
	}

}
