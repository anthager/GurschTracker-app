//: Playground - noun: a place where people can play

import UIKit

class A {
	var int: Int
	init(){
		int = 5
	}
}
class B {
	let a = A()
	init(){
		a.int = 6
	}
}
class C {
	let a: A
	init(a: A) {
		self.a = a
	}
}

let b = B()
let c = C(a: b.a)

print(c.a.int)