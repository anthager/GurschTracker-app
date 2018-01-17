//
//  AddSessionPopupViewController.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-06-06.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit

class AddSessionPopupViewController: UIViewController, UIGestureRecognizerDelegate {

	//MARK: - properties
	var identifier: String?
	var amount = 0

	@IBOutlet weak var window: UIView!
	@IBOutlet var canelGesture: UITapGestureRecognizer!
	@IBOutlet weak var amountTextField: UITextField!
	@IBOutlet weak var wonButton: UIButton!
	@IBOutlet weak var lostButton: UIButton!
	@IBOutlet weak var popupView: UIView!
	@IBOutlet weak var nameLabel: UILabel!

	//MARK: - standard methods
	override func viewDidLoad() {
		super.viewDidLoad()

		amountTextField.text = ""
		canelGesture.delegate = self

		popupView.layer.cornerRadius = 10
		popupView.layer.masksToBounds = true
		amountTextField.becomeFirstResponder()

		nameLabel.text = identifier ?? ""

		disableButtons()
  	}

	//MARK: - actions
	@IBAction func numberTypedInTextField(_ sender: UITextField) {
		let text = sender.text ?? ""
		if text != "", text != "0" {
			if let enteredAmount: Int = Int(text){
				amount = enteredAmount
				enableButtons()
			}
			else {
				print("Non numbers entered in textField")
				return
			}
			enableButtons()
		} else {
			disableButtons()
		}
	}

	@IBAction func addSession(_ sender: UIButton) {
		switch sender {
		case wonButton:
			print("won")
		case lostButton:
			print("lost")
		default:
			fatalError("add session was fired but not by lost- or wonButton")
		}
		self.presentingViewController?.dismiss(animated: true, completion: nil)
	}

	@IBAction func cancel(_ sender: Any) {
		dismiss(animated: true, completion: nil)
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

	//MARK: private methods
	private func disableButtons(){
		wonButton.isEnabled = false
		wonButton.alpha = 0.5
		lostButton.isEnabled = false
		lostButton.alpha = 0.5

	}
	private func enableButtons(){
		wonButton.isEnabled = true
		wonButton.alpha = 1
		lostButton.isEnabled = true
		lostButton.alpha = 1
	}


}
