//
//  ViewController.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-05-30.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDataSource {

	//MARK: - properties
	var opponents: [Opponent] = [] {
		didSet{
			totalAmount = calcTotalAmount()
		}
	}
	var totalAmount = 0
	var persistanceHandler: PersistenceHandler?
	@IBOutlet weak var opponentsTableView: UITableView!
	@IBOutlet weak var totalAmountLabel: UILabel!

	//MARK: - super methods
	override func viewDidLoad() {
		super.viewDidLoad()

//		if let loadedOpponens = loadOpponents() {
//			opponents = loadedOpponens
//		}

		persistanceHandler = PersistenceHandler(opponents: opponents, sessions: [Session](), totalAmountLabel: totalAmountLabel, opponentsTableView: opponentsTableView)

		totalAmount = calcTotalAmount()
		totalAmountLabel.text = String(totalAmount)



	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return opponents.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		// Table view cells are reused and should be dequeued using a cell identifier.

		let cellIdentifier = "OpponentTableViewCell"

		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OpponentTableViewCell  else {
			fatalError("The dequeued cell is not an instance of OpponentTableViewCell.")

		}

		// Fetches the appropriate opponent for the data source layout.
		let opponent = opponents[indexPath.row]

		cell.nameLabel.text = opponent.name
		cell.amountLabel.text = String(opponent.amount)


		return cell

	}

	//MARK: - actions 
	@IBAction func clean(_ sender: Any) {
		//reset()
		print(opponents.count)
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
			popupVC.opponent = opponents[index.row]

		case "addOpponent": break

		case "statistics":
			guard let statisticsVC = segue.destination as? StatisticsViewController else{
				fatalError("VC is not statsVC")
			}

//			statisticsVC.sessions = sessions
			statisticsVC.opponents = opponents
			break


		default:
			fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")

		}
	}

	@IBAction func unwindToOverview(sender: UIStoryboardSegue) {
		if let addSessionVC = sender.source as? AddSessionPopupViewController {

			totalAmount += addSessionVC.amount
			totalAmountLabel.text = String(totalAmount)

			guard let index = opponentsTableView.indexPathForSelectedRow else  {
				fatalError("No row is selected")
			}
			opponentsTableView.reloadRows(at: [index], with: .automatic)

			saveOpponents()

		} else if let addVC = sender.source as? AddOpponentViewController {

			guard let opponent = addVC.opponent else {
				fatalError("no opponent in addOpponentVC")
			}

			let newIndexPath = IndexPath(row: opponents.count, section: 0)
			opponents.append(opponent)
			opponentsTableView.insertRows(at: [newIndexPath], with: .automatic)

			saveOpponents()
		}
	}

	//MARK: - private methods

	private func setupSampleOpponents(){

		guard let opponent1 = Opponent(name: "Peter") else {
			fatalError("Unable to instantiate opponent1")
		}
		guard let opponent2 = Opponent(name: "Adam") else {
			fatalError("Unable to instantiate opponent2")
		}
		guard let opponent3 = Opponent(name: "Petronella") else {
			fatalError("Unable to instantiate opponent3")
		}

		opponents += [opponent1, opponent2, opponent3]
	}

	private func calcTotalAmount() -> Int {
		var amount = 0
		for opponent in opponents {
			amount += opponent.amount
		}
		return amount
	}

	private func getAllSessions(opponents: [Opponent]) -> [Session] {
		var sessions = [Session]()
		for opponent in opponents {
			for session in opponent.sessions {
				sessions.append(session)
			}
		}

		return sessions
	}

	//MARK: saving
	private func saveOpponents(){

	}

	//MARK: loading
	private func loadOpponents() -> [Opponent]? {
		return nil
	}

	//MARK: reseting
	//TODO: Fix the resetting of opponents
	private func resetOpponents(){
	}
	
	private func reset(){
		resetOpponents()
		opponentsTableView.reloadData()

		totalAmount = 0
		totalAmountLabel.text = String(totalAmount)
	}

	//MARK: - firebase
	
}

