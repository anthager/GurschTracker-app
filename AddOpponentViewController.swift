//
//  AddOpponentViewController.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-09.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit

class AddOpponentViewController: UIViewController {

	//MARK: - properties
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!


	//MARK: - superFuncs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }


}
