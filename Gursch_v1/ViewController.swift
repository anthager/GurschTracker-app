//
//  ViewController.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-05-30.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITabBarDelegate {

	//MARK: - properties
	var opponents = [Opponent]()
	var sessions = [Session]()
	@IBOutlet weak var opponentsTableView: UITableView!

	//MARK: - super methods
	override func viewDidLoad() {
		super.viewDidLoad()

		setupSampleOpponents()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return opponents.count
	}


	// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
	// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

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

	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
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


		default:
			fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")

		}
	}

	@IBAction func unwindToOverview(sender: UIStoryboardSegue) {
		if let addSessionVC = sender.source as? AddSessionPopupViewController {

			guard let session = addSessionVC.session else {
				fatalError("No session in addSessionVC")
			}

			sessions.append(session)

			guard let index = opponentsTableView.indexPathForSelectedRow else  {
				fatalError("No row is selected")
			}
			opponentsTableView.reloadRows(at: [index], with: .automatic)

		} else if let addVC = sender.source as? AddOpponentViewController {

			guard let opponent = addVC.opponent else {
				fatalError("no opponent in addOpponentVC")
			}

			let newIndexPath = IndexPath(row: opponents.count, section: 0)
			opponents.append(opponent)
			opponentsTableView.insertRows(at: [newIndexPath], with: .automatic)
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

}

