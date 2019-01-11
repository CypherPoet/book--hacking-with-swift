//: [Previous](@previous)

import Foundation

func ranges() {
    for i in 1...3 {
        print("Closed Range: Step \(i)")
    }
    
    print()
    
    for i in 1..<3 {
        print("Half-Open Range: Step \(i)")
    }
    
    print()
    
    print("Haters gonna ")
    for _ in 1...5 {
        print("hate")
    }
}


func main() {
    ranges()
}


main()

//: [Next](@next)
