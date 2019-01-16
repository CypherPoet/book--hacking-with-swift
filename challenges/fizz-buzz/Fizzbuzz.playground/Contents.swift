import UIKit

/**
 * FizzBuzz Challenge from the Hacking With Swift Guide Book
 *
 * It goes like this:
 *      - Write a function that accepts an integer as input and returns a string.
 *      - If the integer is evenly divisible by 3 the function should return the string “Fizz”.
 *      - If the integer is evenly divisible by 5 the function should return “Buzz”.
 *      - If the integer is evenly divisible by 3 and 5 the function should return “Fizz Buzz”
 *      - For all other numbers the function should just return the input number.
 */


func fizzBuzz(number n: Int) -> String {
    if n % 15 == 0 {
        return "Fizz Buzz"
        
    } else if n % 3 == 0 {
        return "Fizz"
        
    } else if n % 5 == 0 {
        return "Buzz"
        
    } else {
        return String(n)
    }
}


for n in [
    12,
    15,
    5,
    3,
    1,
    0,
    -23,
    23,
    22,
    115,
    100,
] {
    print(fizzBuzz(number: n))
}

