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
	@IBOutlet weak var thisWeekButton: UIButton!
	@IBOutlet weak var thisMonthButton: UIButton!
	@IBOutlet weak var allTimeButton: UIButton!

	var sessions: [Session]?
	var opponents: [Opponent]?

	//MARK: - super funcs
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	//MARK: tableView
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return saflyUnWrappOpponents().count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

		let cellIdentifier = "OpponentTableViewCell"

		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OpponentTableViewCell  else {
			fatalError("The dequeued cell is not an instance of OpponentTableViewCell.")
		}

		let opponent = saflyUnWrappOpponents()[indexPath.row]

		cell.nameLabel.text = opponent.name
		cell.amountLabel.text = String(opponent.amount)


		return cell

	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	//MARK: - private methods 
	private func saflyUnWrappOpponents() -> [Opponent]{
		guard let opponentsSafe = opponents else {
			return [Opponent]()
		}

		return opponentsSafe
	}

	private func saflyUnWrappSessions() -> [Session] {
		guard let sessionsSafe = sessions else {
			return [Session]()
		}

		return sessionsSafe
	}

}
