//: [Previous](@previous)

import Foundation


func arrayTypes() {
    let songs: [String] = [
        "Shake It Off",
        "Welcome to New York",
        "You Belong with Me",
    ]

    type(of: songs)


    let items: [Any] = [
        "This array contains items of",
        2,
        "different data types"
    ]

    type(of: items)
}


func arrayInitialization() {
//    var awards: [String]
//
//    awards[0] = "Grammy"
    let awards: [String] = []

    type(of: awards)
}


func arrayOperators() {
    var awards: [String] = []
    
    awards += ["Grammy", "Oscar"]
    awards.append("Tony")

    print(awards)
}



func main() {
    arrayTypes()
    arrayInitialization()
    arrayOperators()
}


main()


//: [Next](@next)
