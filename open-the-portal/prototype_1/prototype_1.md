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

Current Progress: Animations work now, need to build out a small level to test early ideas and abilities 

### New Enemy Behaviour
I want the enemies to change their behaviour as you go through levels. I am thinking of making the enemies react to different levels in different ways. It will help me to create new behaviour by mostly creating new levels.
Examples:
- normal enemy: runs toward player
- smart enemy: jumps out of the way

types of behaviour changing level content:
potential types: walls, pits, background props, hazards, traps. 
why is there a wall between the player and enemy?
- to stop player hitting enemy easily
- to slow player down
what if the wall is behind the player?
- player is cornered

What about forcefields?
We can create a section where the enemy is protected by bullets from the player. enemies are able to turn on forcefields and survive a few shots from the player. we can make the forcefields have several interesting properties:
- strength: how many shots from player can forcefield take
- distance_from_signal_source: changes strength of forcefield the farther away the enemy is from the signal source
- weak_element: determines which element the forcefield is weak to
- range: how far out from the signal source will the forcefield stop working
- size: the size of the forcefield itself
- material: the physics material used on the forcefield
- static: does the forcefield has a fixed position in the level or is it able to move
- is_enemy_accessory: is the forcefield traveling with the enemy or moving on it's own
- shape: the shape of the forcefield (can be a circle, capsule, rectangle, or an an ellipse)

How can forcefields be brokem?: 
If the strength of the forcefield is lower than the strength of the player's attack, then it will be destroyed, if not it will bounce of in accordance to the physics material, if it has one. Otherwise, it will simply nullify the attack.
The player can also destroy the switches that control the forcefields.  Some enemies are smart and will try to use the forcefields, you can stop them from doing so.

A player hitting an enemy with a bullet should also have the ability to push back the enemy is the strength of the forcefield is low enough or if the strength of the player bullets is high enough.

If a player successfully destroys a forcefield, the enemy should automatically die in an explosion that can disrupt the stability of other forcefields, should knock enemies and even enemies with forcefields back, and damage the strength of nearby forcefields.

#### Expectations
I expect the enemy to know the basics of bullet patterns (and maybe aiming bullets when not using cycle firing), hor forcefields work and how different enemy types react to the player (wether they just run or if they run and jump or if they activate forcefields), and the different enemy types themselves.

I might be removing elements from the the orbs


We will finish making this prototype and if it's not fun, we will change it. If it is, then we will build the rest of the game off of it.
