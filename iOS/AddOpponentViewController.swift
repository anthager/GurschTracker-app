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
	var name: String?


	//MARK: - superFuncs

    override func viewDidLoad() {
        super.viewDidLoad()

		cancelTapGesture.delegate = self

		popupView.layer.cornerRadius = 10
		popupView.layer.masksToBounds = true
		nameTextField.becomeFirstResponder()

		disableButtons()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		name = nameTextField.text
    }

	//MARK: - actions
	@IBAction func cancel(_ sender: UITapGestureRecognizer) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func nameTextFieldWasEdited(_ sender: UITextField) {
		if sender.text != nil && sender.text != "" {
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
