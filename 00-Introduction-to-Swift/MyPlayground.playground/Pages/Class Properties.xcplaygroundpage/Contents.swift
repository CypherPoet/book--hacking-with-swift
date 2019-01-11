//: [Previous](@previous)

import Foundation

struct Person {
    static var species: String = "Homo Sapien"
    var age: Int
    
    var clothes: String {
        willSet {
            updateUI(msg: "I'm changing from \(clothes) to \(newValue)")
        }
        didSet {
            updateUI(msg: "I just changed from \(oldValue) to \(clothes)")
        }
    }
    
    var ageInDogYears: Int {
        return age * 7
    }
    
    func updateUI(msg: String) {
        print(msg)
    }
}


func demo1() {
    var taylor = Person(clothes: "T-Shirt", age: 29)
    
    taylor.clothes = "T-Shirt and Jeans"
}


demo1()
//: [Next](@next)
