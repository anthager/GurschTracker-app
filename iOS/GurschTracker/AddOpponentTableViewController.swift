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

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        return cell
//    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

	//MARK: private funcs

	private func setupTableView(){
		tableView.delegate = self
		tableView.dataSource = nil

		tableView.tableFooterView = UIView() //Prevent empty rows
		//tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("print 1")
		let storyboard = UIStoryboard(name: "AddSession", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "addSession") as! AddSessionPopupViewController
		guard let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell else {
			print("not a user cell")
			return
		}
		controller.user = cell.user

		self.present(controller, animated: true, completion: nil)
		print("print 2")
	}

	private func setupRx(){
		viewModel.users
			.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UserTableViewCell.self)) {
				(row, element, cell) in
				cell.opponent = element.value
				if element.value.name != "" {
					cell.nameLabel.text = element.value.name
				} else {
					cell.nameLabel.text = element.value.email
				}
			}
			.disposed(by: bag)
	}


	deinit {

	}

}
