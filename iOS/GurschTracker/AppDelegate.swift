//
//  AppDelegate.swift
//  Gursch_v1
//
//  Created by Anton Hägermalm on 2017-05-30.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()

		window = UIWindow(frame: UIScreen.main.bounds)

		let sb = UIStoryboard(name: "Main", bundle: nil)
		let controller = sb.instantiateInitialViewController()
		if let vc = controller as? ViewController {
			vc.viewModel.setData(data: ["uid": GTStrings.debugUid])
		}
		let navigationController = UINavigationController(rootViewController: controller!)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()

		return true
	}
}
