import UIKit

extension BinaryInteger {
    func squared() -> Self {
        return self * self
    }
    
    mutating func square() {
        self *= self
    }
}


var a: Int64 = 123_121
var b: UInt8 = 2

a.squared()
b.squared()

print(a)
print(b)

a.square()
b.square()

print(a)
print(b)
