//
//  StatisticsViewController.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-18.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController, UITableViewDataSource {

	//MARK: - properties
	@IBOutlet weak var SessionTableView: UITableView!
	@IBOutlet weak var todayButton: UIButton!
	@IBOutlet weak var sevenDaysButton: UIButton!
	@IBOutlet weak var thirtyDaysButton: UIButton!
	@IBOutlet weak var allTimeButton: UIButton!

	@IBOutlet weak var amountLabel: UILabel!

	var opponents: [Opponent]?
	var totalAmount = 0
//	let timeSettingHandler = TimeSettingHandler.shared

	//MARK: - super funcs
    override func viewDidLoad() {
        super.viewDidLoad()

//		timeSettingHandler.allOpponents = opponents
//		amountLabel.text = String(timeSettingHandler.totalAmount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	//MARK: - actions
	@IBAction func timeSettingButtonPressed(_ sender: UIButton) {
//		switch sender {
//		case todayButton:
//			timeSettingHandler.setToday()
//		case sevenDaysButton:
//			timeSettingHandler.setSevenDays()
//		case thirtyDaysButton:
//			timeSettingHandler.setThirtyDays()
//		case allTimeButton:
//			timeSettingHandler.setAllTime()
//		default:
//			fatalError("timeSettingButtonPressed event was triggered but no button was pressed")
//		}
//
//		opponents = timeSettingHandler.allOpponents
//		totalAmount = timeSettingHandler.totalAmount
//
//		amountLabel.text = String(timeSettingHandler.totalAmount)
//		SessionTableView.reloadData()

	}

	//MARK: - tableView
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//		return timeSettingHandler.opponents?.count ?? 0
		return opponents?.count ?? 0

	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

		let cellIdentifier = "OpponentTableViewCell"

		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OpponentTableViewCell  else {
			fatalError("The dequeued cell is not an instance of OpponentTableViewCell.")
		}

		guard let opponent = opponents?[indexPath.row] else {
			fatalError("Shit's fucked up yo")
		}

		cell.nameLabel.text = opponent.name
//		cell.amountLabel.text = String(timeSettingHandler.amounts?[opponent] ?? 0)
		cell.amountLabel.text = String(opponent.amount)


		return cell

	}

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

	//MARK: - private methods 
	private func saflyUnWrappOpponents() -> [Opponent]{
		guard let opponentsSafe = opponents else {
			return [Opponent]()
		}

		return opponentsSafe
	}

}
