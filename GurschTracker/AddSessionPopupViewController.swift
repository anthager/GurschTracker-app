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
	var opponent: Opponent?
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

		canelGesture.delegate = self

		popupView.layer.cornerRadius = 10
		popupView.layer.masksToBounds = true

		guard let opponent = self.opponent else {
			fatalError("No opponent found")
		}
		nameLabel.text = opponent.name

		disableButtons()

  	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	//MARK: - actions
	@IBAction func buttonPressed(_ sender: UIButton) {
		let buttonName = sender.titleLabel?.text ?? ""
		guard let opponent = self.opponent else {
			fatalError("No opponent found")
		}

		if buttonName == "Lost"{
			amount = -amount

		}
		opponent.addAmount(amount: amount)

	}

	@IBAction func numberTypedInTextField(_ sender: UITextField) {
		let text = sender.text ?? ""

		if text != "", text != "0" {
			if let enteredAmount: Int = Int(text){
				amount = enteredAmount
				enableButtons()
			}
			else {
				fatalError("Non numbers entered in textField")
			}
			enableButtons()
		} else {
			disableButtons()
		}

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		guard let opponent = self.opponent else {
			fatalError("No opponent found")
		}

		if let button = sender as? UIButton {
				if button === lostButton{
					amount = -amount

				}
			opponent.addAmount(amount: amount)

			let session = Session(amount: amount)
			opponent.addSession(session: session)
			print("Adding session")

		} else {
			fatalError("Sender is not a button")
		}
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