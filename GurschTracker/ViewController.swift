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

class ViewController: UIViewController {

	//MARK: - properties

	@IBOutlet weak var opponentsTableView: UITableView!
	@IBOutlet weak var totalAmountLabel: UILabel!
	var state: State?
	var viewModel: ViewModel!
	let bag = DisposeBag()


	//MARK: - super methods

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = ViewModel()
		setupUI()
	}

	//MARK: - actions
	@IBAction func clean(_ sender: Any) {
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

		} else if let addOpponentVC = sender.source as? AddOpponentViewController {

			guard let name = addOpponentVC.name else {
				print("bug: addOpponentVC returned with no name")
				return
			}
			viewModel.newOpponent(name)
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
				cell.nameLabel.text = element.name
				cell.amountLabel.text = String(element.amount)
				}
			.disposed(by: bag)
	}
}

