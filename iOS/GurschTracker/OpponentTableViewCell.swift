//
//  opponentTableViewCell.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-05-30.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit

class OpponentTableViewCell: UITableViewCell {

	//MARK: properties

	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!

	private var _gUser: GUser?
	var gUser: GUser? {
		get{
			return _gUser
		}
		set(new){
			_gUser = new
			if let name = new?.name{
				nameLabel.text = name
			} else if let email = new?.email {
				nameLabel.text = email
			}
		}
	}
	func getUid() -> String?{
		return gUser?.uid
	}
}
