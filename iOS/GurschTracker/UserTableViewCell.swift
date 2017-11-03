//
//  NewOpponentTableViewCell.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-10-30.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {


	@IBOutlet weak var nameLabel: UILabel!

	var user: User?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
