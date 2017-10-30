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
		tableView.delegate = nil
		tableView.dataSource = nil

		tableView.tableFooterView = UIView() //Prevent empty rows
		//tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

	}

	private func setupRx(){
		viewModel.users
			.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: NewOpponentTableViewCell.self)) {
				(row, element, cell) in
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
