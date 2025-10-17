# Prototype 1

## Goal
The player's goal in this game will be to defeat an enemy character. 

### Enemies' abilities
The enemy character will utilize the ricochet ability, one of 2 enemy abilities to hit the orb back at the player.

The player could spam, and i think it's a fun and valid option. Maybe with the right build. 
**Strategies that fits the game's limitations:**
**A)** A specific attack knocks an enemy back and sends them into a knockback animation.
**B)** The player tries hitting from the front and then from behind.
**C)** The player uses a specific attack that may knock the enemy onto a lower platform allowing for vertical projectiles to be thrown.
**D)** A specific attacks knocks the enemy up and into a hit animation where they can't move and can continue to be hit.
**E)** The player shoots one attack from the front and then one on an angled wall that sends the orb near the enemy.

**Options that fit with the simple design of the game**
A) Player uses orb that applies horizontal velocity to enemy characterbody2D. Player fires next orb.
B) Player uses orb from front and then moves behind to fire next orb
C) A + enemy is knocked down onto lower platform and player uses orb from above
D) Player uses orb that applies vertical velocity to enemy chracterbody2D. Player fires next orb.
E) This would require a specific setup for the wall and could only be done in specific areas of the map.
- Instead what could be done is allow for players to define spots (Node2D's) to certain areas in the game world and then instantiate an object from there.
- The only issue is how do we decide the position of those Node2D's. Player Position, Aiming Vector. What does each choice say about potential solutions to the problems im setting out for players?

### Player's abilities
The player will have the ability to shoot multiple orbs by instantiating them

## Expected Outcome
Player uses spawn orb button to spam the enemy with attacks until enemy can no longer defend

## Idea for a future test
Increase enemy count by 1 for each enemy defeated until the player has killed at least 10 enemies.


#### Additional Notes:
I want to add more to this first, but with what i've first decided, i need to decide if their is something worth noticing or changing about the design of the game here.

Current Progress: Shooting bullets works using the arrow keys. Enemy currently does not activate animation when collision is detected. This is due to animation playing automatically updating to "idle" in _process()
