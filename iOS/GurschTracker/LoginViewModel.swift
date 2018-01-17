//
//  LoginViewModel.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2018-01-16.
//  Copyright © 2018 Anton Hägermalm. All rights reserved.
//

import Foundation
class LoginViewModel: ViewModel {
	var uid: String?

	func setData(data: [String : Any]) {
		print("not done")
	}

	func getData() -> [String : Any] {
		return ["uid": uid as Any]
	}
}
