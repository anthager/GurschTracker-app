//
//  Observable.swift
//  GurschTracker
//
//  Created by Anton Hägermalm on 2017-09-12.
//  Copyright © 2017 Anton Hägermalm. All rights reserved.
//

import Foundation

protocol Observable {
	var observers: [Observer] { get set }

	func update()
	func addObserver(observer: Observer)
	//func removeObserver(observer: Observer)
	func removeAllObservers()
}

protocol Observer {
	func stateChanged(observer: Observable)
}

extension Observable {
	func update() {
		for observer in observers {
			observer.stateChanged(observer: self)
		}
	}

	mutating func addObserver(observer: Observer) {
		observers.append(observer)
	}
//	func removeObserver(observer: Observer) {
//		observers.remove(at: observers.ind)
//	}

	mutating func removeAllObservers() {
		observers.removeAll()
	}
}
