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


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	//MARK: actions
	@IBAction func changedAmount(_ sender: Any) {
	}


}
