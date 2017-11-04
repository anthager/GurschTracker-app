//
//  AddOpponentTableViewController.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-10-26.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AddOpponentTableViewController: UITableViewController {

	//MARK: - properties
	var viewModel: ViewModel!
	private let bag = DisposeBag()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
		setupRx()

    }

    // MARK: - Table view data source
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "AddSession", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "addSession") as! AddSessionPopupViewController
		guard let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell else {
			print("not a user cell")
			return
		}
		controller.identifier = cell.nameLabel.text
		controller.viewModel = viewModel
		self.present(controller, animated: true, completion: nil)
	}

	//MARK: private funcs
	private func setupTableView(){
		tableView.delegate = self
		tableView.dataSource = nil
		//tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}

	private func setupRx(){
		viewModel.users
			.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UserTableViewCell.self)) {
				(row, element, cell) in
				cell.player = element.value
				cell.nameLabel.text = element.value.identifier
			}
			.disposed(by: bag)
	}

	deinit {

	}

}
