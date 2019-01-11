//: [Previous](@previous)

import Foundation


enum WeatherType {
    case sun
    case cloud
    case rain
    case wind(speed: Double)
    case snow
}


func getHaterStatus(when weatherType: WeatherType) -> String? {
    switch weatherType {
    case .wind(let speed) where speed < 10:
        return "Calm"
    case .sun, .wind:
        return "Hate"
    case .rain:
        return "Prickly"
    case .cloud, .snow:
        return nil
    }
}


func demo1() {
    print(getHaterStatus(when: .sun))
    print(getHaterStatus(when: .wind(speed: 4.0)))
    print(getHaterStatus(when: .wind(speed: 100.0)))
}


demo1()
//: [Next](@next)
