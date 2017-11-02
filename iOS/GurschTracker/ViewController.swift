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

class ViewController: UIViewController, UITableViewDelegate {

	//MARK: - properties

	@IBOutlet weak var opponentsTableView: UITableView!
	@IBOutlet weak var totalAmountLabel: UILabel!
	private var viewModel: ViewModel!
	private let bag = DisposeBag()


	//MARK: - super methods
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = ViewModel()
		setupUI()
	}

	//MARK: - actions
	@IBAction func addOpponentPressed(_ sender: UIBarButtonItem) {
		let storyboard = UIStoryboard(name: "AddOpponent", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "addOpponentTableView") as! AddOpponentTableViewController
		controller.viewModel = viewModel
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		if let popupVC = segue.destination as? AddSessionPopupViewController {

			guard let index = opponentsTableView.indexPathForSelectedRow else  {
				return
			}
			guard let cell = opponentsTableView.cellForRow(at: index) as? OpponentTableViewCell else {
				return
			}
			popupVC.name = cell.nameLabel.text ?? ""

		}
//		if let statisticsVC = segue.destination as? StatisticsViewController {
//		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "AddSession", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "addSession") as! AddSessionPopupViewController
		guard let cell = tableView.cellForRow(at: indexPath) as? OpponentTableViewCell else {
			return
		}
		controller.name = cell.nameLabel.text ?? ""

		self.present(controller, animated: true, completion: nil)
	}

	@IBAction func unwindToOverview(sender: UIStoryboardSegue) {
		if let addSessionVC = sender.source as? AddSessionPopupViewController {

			guard let identifier = addSessionVC.nameLabel.text else {
				print("bug: addSessionVC returned without a name")
				return
			}
			let amount = addSessionVC.amount
			print("amount = \(amount)")
			viewModel.addSession(opponent: identifier, sessionAmount: amount)

		}
	}

	
	//MARK: - private methods
	func setupUI() {
		viewModel.totalAmount
			.map { amount in
				return String(amount)
			}
			.bind(to: totalAmountLabel.rx.text)
			.disposed(by: bag)

		viewModel.opponents
			.bind(to: opponentsTableView.rx.items(cellIdentifier: "OpponentTableViewCell", cellType: OpponentTableViewCell.self)) {
				(row, element, cell) in
				cell.nameLabel.text = element.value.identifier
				cell.amountLabel.text = String(element.value.amount)
			}
			.disposed(by: bag)
	}
}

