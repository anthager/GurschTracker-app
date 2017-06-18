//
//  AddOpponentViewController.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-09.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit

class AddOpponentViewController: UIViewController, UIGestureRecognizerDelegate {

	//MARK: - properties
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var window: UIView!
	@IBOutlet weak var popupView: UIView!
	@IBOutlet var cancelTapGesture: UITapGestureRecognizer!
	var opponent: Opponent?


	//MARK: - superFuncs

    override func viewDidLoad() {
        super.viewDidLoad()

		cancelTapGesture.delegate = self

		popupView.layer.cornerRadius = 10
		popupView.layer.masksToBounds = true

		disableButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	//MARK: - UIGestureRecognizerDelegate
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

		guard let touchedView = touch.view else {
			fatalError("the touch didn't contain a view")
		}
		if window === touchedView {
			return true
		}
		return false
	}

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let name = nameTextField.text ?? ""

		opponent = Opponent(name: name)
        
    }

	//MARK: - actions
	/*@IBAction func cancel(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}*/
	@IBAction func cancel(_ sender: UITapGestureRecognizer) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func nameTextFieldWasEdited(_ sender: UITextField) {
		let text = sender.text ?? ""

		if text != "" {
			enableButtons()
		}
	}

	//MARK: private methods
	private func disableButtons(){
		doneButton.isEnabled = false
		doneButton.alpha = 0.5
	}
	private func enableButtons(){
		doneButton.isEnabled = true
		doneButton.alpha = 1
	}
}
