//: [Previous](@previous)

import Foundation


/// `arc4random` is the classic way to generate random numbers.
/// It generates a number between 0 and 4,294,967,295, giving a range of 2^(32 - 1)
print(arc4random())

/// We can constrain this with a modulus
print(arc4random() % 42)


/// But to prevent [modulo bias](https://zuttobenkyou.wordpress.com/2012/10/18/generating-random-numbers-without-modulo-bias/), we can just pass our constraint as an argument
print(arc4random_uniform(42))


func randomBetween(min: Int, max: Int) -> Int {
    guard min < max else { return min }
    
    let randomFactor = Int(arc4random_uniform(UInt32((max - min) + 1)))
    
    return randomFactor + min
}

for i in 0..<10 {
    print(randomBetween(min: 4, max: 10 + (i * 10)))
}


/// So yeah... Swift's newer randomness methods are much nicer 😎
print(Int.random(in: 100...1000))
print(Double.random(in: 100...1000))
print(Float.random(in: 100...1000))
print(Bool.random())



//: [Next](@next)
