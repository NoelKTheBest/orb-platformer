# Welcome to the Game Design Document for *Open the Portal*!

This will be a 2D platformer using the Godot game engine with the default renderer and using Git for source control. The main idea of the game is to create a game using a power absorption mechanic. The main two powers will be metal and flame. I may include other abilities in the future such as rock, water, lightning, wind, and plasma. 
I want to also include some early ideas that I have for the idea of combo games where instead of using attacks to perform combos, you use projectiles.

# Mechanics

The main mechanic in the game is an ability to steal an opponents' abilities to use for your own attacks. If your absorption bubble collides with an attack projectile, it will assume the properties of that projectile. This will provide opportunities for different types of attacks for tougher enemies. 

### Ricochet

The player will be able to ricochet their attacks to allow them to hit enemies twice. Attacks used will harm the player but with less damage (?) unless the player hit's it back and causes the attack to bounce again. The attack can bounce off in only in the direction in which it was struck.

### Release Stored Power

The player will have the ability to release their stored power for an additional attack and boost. The player can only hold 3 abilities for now. 

### Aiming

The player will be able to throw the ball in 8 directions and the balls will allows be reflected according to the surface normals

### Call Back

The player will have the ability to call back a launched attack and have it do damage to anything it hits on the way back, including the player.

## Abilities

### Metal

Metal abilities will cause knockback

### Flame 

Flame abilities will cause burn damage

## Enemies

### Basic Enemy Abilities

Some basic enemy abilities will include:

- **Ricochet**: Hitting an orb back at the player to defend
- **Parry**: Complete defense of a player's attack which nullifies it

### Boss Abilities:

Bosses will have access to all basic enemy abilities including:
- **Dodge**: Avoid a players attack with a well timed evade.
- **Counter Attack**: Launch another attack to counter the player's attack, nullifying both
- 

# Story
## Main Character: Emily
The main character of the game is called Emily (for now). She is a young woman looking to get home from being in outer space. Her squad was completely wiped out by an enemy horde and now she has to use a unique ability of hers in order to escape with her life and reach the portal that will take her back to her home world of Zena.

# Art
## Characters

For the main character of the game we will be using this pixel art sprite asset: **2D Pixel Art Character Template Asset Pack  by ZeggyGames.**

For enemy characters, we need characters that use two of the main abilities in their attacks such as metal enemies and fire enemies. If we decide to add in more characters, we also need enemies of this type as well. We should be able to find what we need on itch

## Backgrounds
The backgrounds will be sci fi  in spaced, probably on a space station or something like that.

# Sound Design

I want the attacks to sound good and the hits to really feel like they hit something hard. I want all the characters to have voice clips that sound like they are attacking or getting hurt. I want the menu to have some basic click, confirm and cancel sounds

# Music
I want the music in the game to be fast paced and fun with a few slower tracks to balance out everything.

# **Platforms**
I want to start with a web release.
- If that goes well then a desktop release through steam with gamepad support.
Accessibility is also important to me so I want two ways of controlling the character that I think would work well. One way is to press up on the same set of keys and then press in a direction you want to shoot while airborne. Pressing up should slow the player's descent for a split second until a timer runs out. This is important if the player is playing on a keyboard without arrow keys. Or maybe they just prefer something different.
