//: Playground - noun: a place where people can play

import UIKit


func dispatchDemo (){
	let group = DispatchGroup()
	let queue = DispatchQueue(label: "1")
	let queue2 = DispatchQueue(label: "2")
	let queue3 = DispatchQueue(label: "3")
	let queue4 = DispatchQueue(label: "4")

	queue.sync {
		for i in 1...10 {
			print("\(i) - 1")

		}
		queue2.async {
			for i in 1...10 {
				print("T" + "H" + "I" + "S")
			}
		}
	}
	queue.sync {
		for i in 1...10 {
			print("\(i) - asd")
		}
	}

}

dispatchDemo()
