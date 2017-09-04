//: Playground - noun: a place where people can play

import UIKit

let date = Date()
let dateString = date.description

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

let date2 = dateFormatter.date(from: dateString)
let dateString2 = date2?.description

dateString == dateString2