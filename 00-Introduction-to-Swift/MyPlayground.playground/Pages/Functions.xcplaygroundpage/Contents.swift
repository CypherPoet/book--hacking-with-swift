//: [Previous](@previous)

import Foundation


func logLetters(string: String) {
    print("The string \"\(string)\" has \(string.count) letters")
}


func logLetters(in string: String) {
    print("The string \"\(string)\" has \(string.count) letters")
}

func logLetters(_ str: String) {
    print("The string \"\(str)\" has \(str.count) letters")
}

func isAlbumTaylors(name: String) -> Bool {
    return [
        "Taylor Swift",
        "Fearless",
        "Speak Now",
        "1989",
        "Red",
        "Reputation"
    ].contains(name)
}


func getHaterStatus(weather: String) -> String? {
    if weather == "Sunny" {
        return nil
    } else {
        return "Hate"
    }
}


func getAlbumReleaseYear(name: String) -> Int? {
    if name == "Taylor Swift" { return 2006 }
    if name == "Fearless" { return 2008 }
    if name == "Speak Now" { return 2010 }
    if name == "Red" { return 2012 }
    if name == "1989" { return 2014 }
    if name == "Reputation" { return 2017 }
    
    return nil
}



func externalAndInternalParameters() {
    logLetters(string: "Fearless")
    logLetters(in: "Hide")
    logLetters("Solo")
}

func returnTypes() {
    print(isAlbumTaylors(name: "A Better Tomorrow"))
    print(isAlbumTaylors(name: "1989"))
}


func optionals() {
//    var status: String
    var status: String?
    
    status = getHaterStatus(weather: "Stormy")
    status = getHaterStatus(weather: "Sunny")
    
    if let unwrappedStatus = status {
        print("Hater status confirmed")
    } else {
        print("No hater status")
    }
    
    if let newStatus = getHaterStatus(weather: "Hot") {
        print("Hater status confirmed")
    }
}


func forceUnwrapping() {
    let year = getAlbumReleaseYear(name: "Red")
    
    
    if (year == nil) {
        print("No release year found")
    } else {
        print("Release Year: \(year!)")
    }
}



externalAndInternalParameters()
returnTypes()
optionals()
forceUnwrapping()

//: [Next](@next)
