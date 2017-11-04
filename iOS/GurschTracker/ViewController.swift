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

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "AddSession", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "addSession") as! AddSessionPopupViewController
		guard let cell = opponentsTableView.cellForRow(at: indexPath) as? OpponentTableViewCell else {
			return
		}
		controller.identifier = cell.nameLabel.text
		controller.viewModel = viewModel
		self.present(controller, animated: true, completion: nil)
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

