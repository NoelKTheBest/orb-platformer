# Prototype 1

## Goal
The player's goal in this game will be to defeat an enemy character. 

### Enemies' abilities
The enemy character will utilize the ricochet ability, one of 2 enemy abilities to hit the orb back at the player.

### Player's abilities
The player will have the ability to shoot multiple orbs by instantiating them

## Expected Outcome
Player uses spawn orb button to spam the enemy with attacks until enemy can no longer defend

## Idea for a future test
Increase enemy count by 1 for each enemy defeated until the player has killed at least 10 enemies.


#### Additional Notes:
I want to add more to this first, but with what i've first decided, i need to decide if their is something worth noticing or changing about the design of the game here.

Current Progress: Shooting bullets works using the arrow keys. Enemy currently does not activate animation when collision is detected. This is due to animation playing automatically updating to "idle" in _process()
