//
//  ViewController.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-05-30.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDataSource, Observer {

	//MARK: - properties

	@IBOutlet weak var opponentsTableView: UITableView!
	@IBOutlet weak var totalAmountLabel: UILabel!
	var state: State?


	//MARK: - super methods

	override func viewDidLoad() {
		super.viewDidLoad()
		state = State(tableView: opponentsTableView, label: totalAmountLabel)
		PersistenceHandler(state: state!)

		//		if let loadedOpponens = loadOpponents() {
		//			opponents = loadedOpponens
		//		}

		//totalAmount = calcTotalAmount()
		totalAmountLabel.text = String(describing: state?.totalAmount)
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return state!.opponents.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		// Table view cells are reused and should be dequeued using a cell identifier.

		let cellIdentifier = "OpponentTableViewCell"

		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OpponentTableViewCell  else {
			fatalError("The dequeued cell is not an instance of OpponentTableViewCell.")

		}

		// Fetches the appropriate opponent for the data source layout.
		let opponent = state?.opponents[indexPath.row]

		cell.nameLabel.text = opponent!.name
		cell.amountLabel.text = String(describing: opponent?.amount)


		return cell

	}

	//MARK: - actions
	@IBAction func clean(_ sender: Any) {
		//		reset()
		//		totalAmountLabel.text = String(totalAmount)
		//		opponentsTableView.reloadData()
	}

	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		switch(segue.identifier ?? "") {
		case "addSession":
			guard let popupVC = segue.destination as? AddSessionPopupViewController else {
				fatalError("Unexpected destination: \(segue.destination)")
			}

			guard let index = opponentsTableView.indexPathForSelectedRow else  {
				fatalError("No row is selected")
			}
			popupVC.opponent = state?.opponents[index.row]

		case "addOpponent": break

		case "statistics":
			guard let statisticsVC = segue.destination as? StatisticsViewController else{
				fatalError("VC is not statsVC")
			}

			//			statisticsVC.sessions = sessions
			statisticsVC.opponents = state?.opponents
			break


		default:
			fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")

		}
	}

	@IBAction func unwindToOverview(sender: UIStoryboardSegue) {
		if let addSessionVC = sender.source as? AddSessionPopupViewController {

			state?.addToTotalAmount(addSessionVC.amount)
			totalAmountLabel.text = String(describing: state?.totalAmount)

			guard let index = opponentsTableView.indexPathForSelectedRow else  {
				fatalError("No row is selected")
			}
			opponentsTableView.reloadRows(at: [index], with: .automatic)

		} else if let addVC = sender.source as? AddOpponentViewController {

			guard let opponent = addVC.opponent else {
				fatalError("no opponent in addOpponentVC")
			}
			state?.opponents.append(opponent)
			opponentsTableView.reloadData()
		}
	}

	//MARK: - observer funcs

	func stateChanged(observer: Observable) {
		opponentsTableView.reloadData()
	}

	//MARK: - private methods
	
	//MARK: reseting
	
	private func resetOpponents(){
	}
}

