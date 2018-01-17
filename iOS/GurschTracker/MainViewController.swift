//
//  ViewController.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-05-30.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseDatabaseUI

class MainViewController: UIViewController, ViewController{
	var viewModel: ViewModel = MainViewModel()

	//MARK: - properties
	@IBOutlet weak var opponentsTableView: UITableView!
	@IBOutlet weak var totalAmountLabel: UILabel!
	var databaseRef: DatabaseReference?
	var databaseHandle: DatabaseHandle?
	var dataSource: FUITableViewDataSource?

	//MARK: - super methods
	override func viewDidLoad() {
		super.viewDidLoad()
		self.databaseRef = Database.database().reference().child(GTStrings.publicNode)
		opponentsTableView.dataSource = nil
		opponentsTableView.delegate = nil
		setupUI()
	}

	//MARK: - actions
	@IBAction func addOpponentPressed(_ sender: UIBarButtonItem) {
		print("pressed")
//		let storyboard = UIStoryboard(name: "AddOpponent", bundle: nil)
//		let controller = storyboard.instantiateViewController(withIdentifier: "addOpponentTableView") as! AddOpponentTableViewController
//		controller.viewModel = viewModel
//		self.navigationController?.pushViewController(controller, animated: true)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("pressed")
//		let storyboard = UIStoryboard(name: "AddSession", bundle: nil)
//		let controller = storyboard.instantiateViewController(withIdentifier: "addSession") as! AddSessionPopupViewController
//		guard let cell = opponentsTableView.cellForRow(at: indexPath) as? OpponentTableViewCell else {
//			return
//		}
//		controller.identifier = cell.nameLabel.text
//		controller.viewModel = viewModel
//		self.present(controller, animated: true, completion: nil)
	}


	private func setupUI(){
		guard let query = databaseRef?.queryOrderedByValue() else {
			print("returning")
			return
		}

		dataSource = opponentsTableView.bind(to: query, populateCell: { (tableView, indexPath, snap) -> UITableViewCell in
			print("inside")
			let cell = tableView.dequeueReusableCell(withIdentifier: "opponentTableViewCell", for: indexPath) as! OpponentTableViewCell

			let gUser = GUser(snapshot: snap)
			cell.amountLabel.text = "10"
			cell.nameLabel.text = gUser?.email
//			cell.nameLabel.text = "gUser?.uid"
			return cell
		})
	}
}
