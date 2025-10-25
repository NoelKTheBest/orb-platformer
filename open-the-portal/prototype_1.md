# Prototype 1

## Goal
The player's goal in this game will be to defeat an enemy character. 

### Enemies' abilities
There will be 2 new types of enemy abilities in the game, one enemy will run straight towards you and try to hit you. They will have no defenses and will just take hits. Another enemy will run towards you and try to jump. And finally, a stronger enemy will shoot their own projectile at the player. I am redesigning some of the games skills in order to more closely fit in with the smooth learning curve i have in mind in this game. I want the basic components of enemy behaviour to be simple to understand and the options you need to respond to that behaviour simple to use.

Now the player can just hit enemies as they jump (player will have multiple points from where they can attack enemies), but i am removing the the defensive abilities in this system, with that being the parry. The ricochet can stay in but only if the enemies use an attack to hit the projectile back (the enemies can only hit projectiles once in a 5-10 second interval for this first prototype).

The player could spam, and i think it's a fun and valid option. Maybe with the right build.

### Player's abilities
The player will have the ability to shoot multiple orbs by instantiating them

## Expected Outcome
Player uses keystrokes to activate the projectile combo chain, attacking from the front and then from a different point.


#### Additional Notes:
I want to add more to this first, but with what i've first decided, i need to decide if their is something worth noticing or changing about the design of the game here.

Current Progress: Shooting bullets works using the arrow keys. Enemy currently does not activate animation when collision is detected. This is due to animation playing automatically updating to "idle" in _process()
