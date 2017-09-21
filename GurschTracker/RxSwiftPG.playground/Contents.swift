//: Playground - noun: a place where people can play

import UIKit
import RxSwift

let names = Variable(["Karl"])

names.asObservable()
//	.subscribe(onNext: { value in
//		print(value)
//	})
	.subscribe { (<#Event<[String]>#>) in
		<#code#>
}


names.value.append("Pelle")

