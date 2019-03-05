# ESP Tester (Zener Test Clone)

This project builds a simple game that recreates the classic [Zener test](https://en.wikipedia.org/wiki/Zener_cards) for extrasensory perception. Our game will show the user eight cards face down, and users need to tap the card that has a star on its flip side. Casual players will get it right 1 in 8 times, but we'll get it right every time.

How do we gain this edge? First, we're going to build a tiny watchOS app that silently taps our wrist when our finger moves over the star card. Then we're going to add 3D Touch support so that pressing hard on any card will automatically make it the star.
