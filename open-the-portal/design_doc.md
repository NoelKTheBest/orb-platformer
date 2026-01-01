# Welcome to the Game Design Document for *Open the Portal*!

This will be a 2D sidescrolling game using the Godot game engine with the default renderer and using Git for source control.

# Mechanics

The player has the ability to jump to avoid enemies and to shoot small orbs at them to knock them out, effectively eliminating them as a threat.

The other main mechanic is an orb that pushes back enemies. This orb can be cancelled out however.

Using the special orb and your jump ability, you have to use the tools at your advantage to control the space around you and make it out alive.

I would also like to use this as a way to teach to the player that they may run into situations that completely change enemy behaviour and that create new dynamics and interactions for the player to think through.

The game may feature spawn points in some levels, but may mostly spawn enemies from offscreen to target the enemy at the center of the screen.

We will continue to do ongoing playtesting that improves the experience and refines the gameplay, but I am confident that with the baseline features currently present in the demo that I can move forward with production and knowing that the game itself is fun and enjoyable.

## Powerups
The game will feature a variety of powerups that give more options for the player to plan how they will survive the encounter

### Energy Regeneration
This ability will completely restore the player's energy levels and for a limited time either give them a boost in energy or reduce energy costs so the player has a chance to fire more often.

### Shield
This will create a shield around the player to protect them from damage.

### EMP
This will send a shockwave through the ground completely paralyzing all enemies in place for a specific amount of time and give the player the chance to equal out the playing field. Need's lots of testing.

**The following powerups will need to be thoroughly tested to ensure that they work well**

### Shield Regeneration
This will regenerate one of the player's sheilds. More advanced versions of this powerup can regenerate both shields and I may also want to give them an extra shield for extra protection

### Walkie Talkie
This will allow the player to temporarily give commands to the enemies which will allow them to throw off an enemy's plan of attack or even disrupt/distract one of the stronger enemies

### Sword
This gives the player access to a sword which will change the behaviour of some enemies. They may wait for you to strike or they may use a different attack instead. In addition to this, the sword can only be used once as a last resort if it collides with the enemy's weapon. You can strike with it too but only at close range and it cannot be used at the same time with the gun.

### Grenade
This is a smoke grenade that the player can throw to disperse enemies.

# Tools
We need tools to create enemy behaviour, levels using tilesets and parallax backgrounds, creating cutscenes and basic dialog, playing music dynamically based on the situation, detecting area to area and area to body overlaps, playing sound fx
  ## Transferring level in Asesprite to Godot
  I will be making a majority of specific art assets that i will need for the game in aseprite and want to be able to just plop them into the game without much issue. I can't possibly design the whole level in aseprite as a level in a game like this could end up being really really big. Godot does already make this easy, but I also want to be able to create enemy spawn hubs/points and simply tell the game to spawn enemies at that location to make playtesting easier. The same could be done for certain props like a forcefield controller or some other kind of interactable machine or device.

  The levels will be built like obstacle courses themselves with enemy locations being set to somewhere specific in the obstacle course and enemies being made to be instantiated there at runtime so we can refer to an area by a name or tag and say "Spawn Enemy at [insert tag name here]". And there should be not only an order but automatic spacing for props. The tileset is what i will use to build the platforms so that won't be affected, but simple sprites for the props themselves will. In addition to all this, I would want a way to hit a button to create a new node at the mouse cursor position to set it in the scene and have that be the position. But this isn't necessary and depending on how big the levels are, none of this may be necessary.

# Story
## Main Character: KALA
The main character of the game is called Kala. She is a young woman looking to get home from being in outer space. Her squad was completely wiped out by an enemy horde and now she has to use a unique ability of hers in order to escape with her life and reach the portal that will take her back to her home world of Zena. The enemy wants to unlock the secret of portal technology but can't read the documentation on the ship and need the mc to translate.
## Enemy Language
This will only be relevant for certain moments in the game.

# Art
I will be looking for placeholder assets for now until I have a team and if not, then I will edit the assets.

## Characters

There will be basic enemies and commanders.

## Backgrounds
The backgrounds will be sci fi  in space, probably on a space station or something like that.

# Sound Design

I want the attacks to sound good and the hits to really feel like they hit something hard. I want all the characters to have voice clips that sound like they are attacking or getting hurt. I want the menu to have some basic click, confirm and cancel sounds

# Music
I want the music in the game to be fast paced and fun with a few slower tracks to balance out everything.

# **Platforms**
I want to start with a web release.
- If that goes well then a desktop release through steam with gamepad support.
Accessibility is also important to me so I want two ways of controlling the character that I think would work well. One way is to press up on the same set of keys and then press in a direction you want to shoot while airborne. Pressing up should slow the player's descent for a split second until a timer runs out. This is important if the player is playing on a keyboard without arrow keys. Or maybe they just prefer something different.
