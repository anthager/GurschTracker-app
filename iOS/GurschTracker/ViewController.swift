//
//  ViewController.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-05-30.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import FirebaseDatabase
import RxSwift
import RxCocoa
import FirebaseDatabaseUI

class ViewController: UIViewController, UITableViewDelegate {

	//MARK: - properties
	@IBOutlet weak var opponentsTableView: UITableView!
	@IBOutlet weak var totalAmountLabel: UILabel!
	//private var viewModel: ViewModel!
	private let bag = DisposeBag()
	var databaseRef: DatabaseReference?
	var databaseHandle: DatabaseHandle?
	var dataSource: FUITableViewDataSource? = nil



	//MARK: - super methods
	override func viewDidLoad() {
		super.viewDidLoad()
		self.databaseRef = Database.database().reference().child("users")
		//viewModel = ViewModel()
		opponentsTableView.dataSource = nil
		opponentsTableView.delegate = nil
		setupUI()
	}

	//MARK: - actions
	@IBAction func addOpponentPressed(_ sender: UIBarButtonItem) {
//		let storyboard = UIStoryboard(name: "AddOpponent", bundle: nil)
//		let controller = storyboard.instantiateViewController(withIdentifier: "addOpponentTableView") as! AddOpponentTableViewController
//		controller.viewModel = viewModel
//		self.navigationController?.pushViewController(controller, animated: true)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
		guard let query = databaseRef?.queryOrderedByKey() else {
			return
		}
		dataSource = opponentsTableView.bind(to: query, populateCell: { (tableView, indexPath, snap) -> UITableViewCell in
			print("inside")
			let cell = tableView.dequeueReusableCell(withIdentifier: "OpponentTableViewCell", for: indexPath) as! OpponentTableViewCell

			let gUser = GUser(snapshot: snap)
			cell.amountLabel.text = "10"
			cell.nameLabel.text = gUser?.uid
			return cell
		})
	}
}
