//
//  AddOpponentTableViewController.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-10-26.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit

class AddOpponentTableViewController: UITableViewController {

	//MARK: - properties

    override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()

    }

    // MARK: - Table view data source
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "AddSession", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "addSession") as! AddSessionPopupViewController
		guard let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell else {
			print("not a user cell")
			return
		}
		self.present(controller, animated: true, completion: nil)
	}

	//MARK: private funcs
	private func setupTableView(){
		tableView.delegate = self
		tableView.dataSource = nil
		//tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}



}
