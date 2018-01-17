//
//  MainViewModel.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-15.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import Foundation
class MainViewModel: ViewModel {
	var uid: String!
	func setData(data: [String : Any]) {
		guard let uid = data["uid"] as? String else {
			fatalError("didnt get a uid")
//			print("was unable to pack up data in MainVM")
//			return
		}
		self.uid = uid
	}

	func getData() -> [String : Any] {
		return ["uid" : uid]
	}
}
