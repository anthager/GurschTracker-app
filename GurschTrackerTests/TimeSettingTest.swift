//
//  TimeSettingTest.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-23.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import XCTest
@testable import GurschTracker

class TimeSettingTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
		let opponents = Opponent.testSetup()

		TimeSettingHandler.shared.allOpponents = opponents
    }

	func testOpponents(){
		XCTAssertTrue(TimeSettingHandler.shared.opponents!.count == 2)
	}
//test might fail depending on what time of the day it's run
    func testOpponentSession(){
		let opponents: [Opponent] = TimeSettingHandler.shared.opponents!

		let dirr = TimeSettingHandler.shared.opponentSessions!
		let sessions: [Session] = dirr[opponents[0]]!

		XCTAssertTrue(sessions.count == 2 && dirr.count == 2)
		//print("sessions for peter = \(sessions.count) and dirrCount = \(dirr.count)")
	}
//test might fail depending on what time of the day it's run
	func testAllSessions(){
		//print("sessionCount = \(TimeSettingHandler.shared.sessions!.count)")
		XCTAssertTrue(TimeSettingHandler.shared.sessions!.count == 4)
	}

	func testAmounts(){
		let opponents: [Opponent] = TimeSettingHandler.shared.opponents!

		XCTAssert(TimeSettingHandler.shared.amounts![opponents[0]]! == 20)
	}

	func testTotalAmounts(){
		XCTAssert(TimeSettingHandler.shared.totalAmount == 40)
	}
}
