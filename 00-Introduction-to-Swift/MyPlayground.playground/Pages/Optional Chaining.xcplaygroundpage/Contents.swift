//: [Previous](@previous)

import Foundation

func getAlbumReleaseYear(for name: String) -> Int? {
    if name == "Taylor Swift" { return 2006 }
    if name == "Fearless" { return 2008 }
    if name == "Speak Now" { return 2010 }
    if name == "Red" { return 2012 }
    if name == "1989" { return 2014 }
    if name == "Reputation" { return 2017 }
    
    return nil
}

func getAlbumReleased(in year: Int) -> String? {
    if year == 2006 { return "Taylor Swift" }
    if year == 2008 { return "Fearless" }
    if year == 2010 { return "Speak Now" }
    if year == 2012 { return "Red" }
    if year == 2014 { return "1989" }
    if year == 2017 { return "Reputation"  }
    
    return nil
}


func demo1() {
    let album = getAlbumReleased(in: 2006)
    
    print("\(album?.uppercased()) was released in 2006")
}


func nilCoalescingDemo() {
    let album = getAlbumReleased(in: 2006)
    
    print("\(album ?? "Nothing that we know of") was released in 2006")
}


demo1()
nilCoalescingDemo()

//: [Next](@next)
