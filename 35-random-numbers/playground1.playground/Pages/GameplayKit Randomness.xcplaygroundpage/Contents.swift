import UIKit
import GameplayKit


let sharedRandom = GKRandomSource.sharedRandom()

print(sharedRandom.nextInt())
print(sharedRandom.nextInt())
print(sharedRandom.nextInt())

print(sharedRandom.nextInt(upperBound: 20))
print(sharedRandom.nextInt(upperBound: 20))
print(sharedRandom.nextInt(upperBound: 20))

print(sharedRandom.nextBool())
print(sharedRandom.nextUniform())


/**
    Using the system's built-in random number source is exactly what you want when you just need something simple.
    But the system's random number generator is not deterministic,
    which means you can't predict what numbers it will output because it
    always starts in a different state – and that makes it useless for synchronizing network games.
 */


/**
    Fortunately, GameplayKit offers three custom sources of random numbers,
    all of which are deterministic, and all of which can be
    serialized – i.e., written out to disk using something like NSCoding:
 
    1. `GKLinearCongruentialRandomSource`: Slightly higher performance than Arc4, but lower randomness
    2. `GKMersenneTwisterRandomSource`: High randomness, but slightly lower performance than Arc4
    3. `GKARC4RandomSource`: Goldilocks random source
 
    ⚠️ While deterministic, none of these ar cryptographically secure
 */

let linearCongruential = GKLinearCongruentialRandomSource()
print(linearCongruential.nextInt(upperBound: 20))


let twister = GKMersenneTwisterRandomSource()
print(twister.nextInt(upperBound: 20))


let arc4 = GKARC4RandomSource()

/**
    ⚠️ Apple recommends you force flush its ARC4 random number generator before using it
    for anything important, otherwise it will generate sequences that can be
    guessed to begin with. Apple suggests dropping at least the first 769.
 */

arc4.dropValues(1024)

print(arc4.nextInt(upperBound: 20))
