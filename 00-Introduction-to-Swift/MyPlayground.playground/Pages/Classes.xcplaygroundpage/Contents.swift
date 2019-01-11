//: [Previous](@previous)

import Foundation


class Singer {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func sing() {
        print("La la la")
    }
}

class RockSinger: Singer {
    override func sing() {
        print("Yeah yeah yeah")
    }
}


class HeavyMetalSinger: Singer {
    var noiseLevel: Int
    
    init(name: String, age: Int, noiseLevel: Int) {
        self.noiseLevel = noiseLevel
        
        super.init(name: name, age: age)
    }
    
    override func sing() {
        print("Grrrrrr rrr")
    }
}


func demo1() {
    let taylor = Singer(name: "Taylor Swift", age: 29)
    let bono = RockSinger(name: "Bono", age: 100)
    let metalSinger = HeavyMetalSinger(name: "Rage", age: 10, noiseLevel: 2)
    
    bono.sing()
    metalSinger.sing()
}


func instancesAreCopiedByReference() {
    let taylor = Singer(name: "Taylor Swift", age: 29)
    let imposter = taylor
    
    imposter.age = 33
    
    print(taylor.age)
}



demo1()
instancesAreCopiedByReference()
//: [Next](@next)
