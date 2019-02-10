import UIKit

extension Int {
    mutating func increment() {
        self += 1
    }
    
    var squared: Int {
        return self * self
    }
    
}


var myInt1 = 0
let myInt2 = 232


myInt1.increment()
//myInt2.plusOne()
//2.plusOne()
