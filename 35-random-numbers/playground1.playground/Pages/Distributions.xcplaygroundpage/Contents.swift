//: [Previous](@previous)

import UIKit
import GameplayKit

// six-sided die
let d6 = GKRandomDistribution.d6()
d6.nextInt()

// twenty-sided die
let d20 = GKRandomDistribution.d20()
d20.nextInt()


let crazyDie = GKRandomDistribution(lowestValue: 20, highestValue: 23508)
crazyDie.nextInt()

// ⚠️ Going out of bounds will straight-up crash things, though
// crazyDie.nextInt(upperBound: 1)


/// Distributions can have a custom source of randomness
let twisterEngine = GKMersenneTwisterRandomSource()
print(GKRandomDistribution(randomSource: twisterEngine, lowestValue: 10, highestValue: 1000).nextInt())


/**
 Sometimes, though, we don't want completely realistic randomness: We might
 want to avoid repeats. We might also want our distribution to be non-uniform --
 for example, a Gaussian distribution
 */

/**
 `GKShuffledDistribution` is an anti-clustering distribution, which means it
 shapes the distribution of random numbers so that you are less
 likely to get repeats. This means it will go through every
 possible number before you see a repeat, which makes for a
 truly perfect distribution of numbers.
 */
let shuffledDistribution = GKShuffledDistribution.d6()

for roll in 1...6 {
    print("Roll \(roll): \(shuffledDistribution.nextInt())")
}


let gaussianDistribution = GKGaussianDistribution(lowestValue: 0, highestValue: 20)
var counts: [Int : Int] = [:]

for _ in 1...100_000 {
    let result = gaussianDistribution.nextInt()
    
    if let currentCount = counts[result] {
        counts[result] = currentCount + 1
    } else {
        counts[result] = 1
    }
}

for number in 1...20 {
    print("\(number): \(counts[number]!)")
}


/**
 Random number generators consist of two components: A source (sometimes synonymous with "engine") and a distribution.
 The entropic output of the source/engine is mapped onto the distribution to produce a final value.
 
 This is important, because we can _seed_ engines -- give them specific starting point. When
 an engine is deterministic, using a common seed allows us to reproduce the same random output
 across systems and individual game runs.
 */


let twisterEngineA = GKMersenneTwisterRandomSource(seed: 42)
let twisterEngineB = GKMersenneTwisterRandomSource(seed: 42)

let options = [Int](0...200)

let selectionA = twisterEngineA.arrayByShufflingObjects(in: options)[0..<6]
let selectionB = twisterEngineB.arrayByShufflingObjects(in: options)[0..<6]

print(selectionA)
print(selectionB)


//: [Next](@next)
