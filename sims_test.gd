extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#original arrays: 
#player attacker dice array: [2, 2, 2, 1, 3] player defender dice array: [2, 1, 1, 2, 3]
#target defender dice array: [2, 4, 2, 3]target attacker dice array: [2, 4, 8]
#after combat results: 
#player attacker dice array: [1] player defender dice array: [1, 1, 2, 3]
#target defender dice array: []target attacker dice array: [8, 4]
#----------------
#attack damage dealt from player to target: 
#sum of player attack dice = 1
#the player's weapon's graze modifier is = 0
#target dodge threshold is = 1
#the player deals this much damage target = 0
#----------------
#attack damage dealt from target to player: 
#sum of player attack dice = 12
#the target's weapon's graze modifier is = 2
#player dodge threshold is = 8
#the target deals this much damage to player = 4

#player rolled low and the damage didn't get thru
#warrior rolled super high and the player dodged some


#original arrays: 
#player attacker dice array: [1, 2, 2, 2, 2] player defender dice array: [1, 3, 2, 2, 3]
#target defender dice array: [3, 2, 3, 3]target attacker dice array: [2, 3, 2]
#after combat results: 
#player attacker dice array: [1] player defender dice array: [1, 3]
#target defender dice array: []target attacker dice array: []
#----------------
#attack damage dealt from player to target: 
#sum of player attack dice = 1
#the player's weapon's graze modifier is = 0
#target dodge threshold is = 1
#the player deals this much damage target = 0
#----------------
#attack damage dealt from target to player: 
#sum of player attack dice = 0
#the target's weapon's graze modifier is = 4
#player dodge threshold is = 8
#player's modified dodge threshold is = 4
#the target deals this much damage to player = -4

#both parties rolled low. no damage got through
#possible counter attack since the enemy rolled negative damage


#original arrays: 
#player attacker dice array: [2, 1, 2, 2, 3] player defender dice array: [2, 3, 2, 2, 3]
#target defender dice array: [1, 5, 3, 2]target attacker dice array: [1, 2, 5]
#after combat results: 
#player attacker dice array: [2] player defender dice array: [2, 3, 3]
#target defender dice array: []target attacker dice array: [5]
#----------------
#attack damage dealt from player to target: 
#sum of player attack dice = 2
#the player's weapon's graze modifier is = 0
#target dodge threshold is = 1
#the player deals this much damage target = 1
#----------------
#attack damage dealt from target to player: 
#sum of player attack dice = 5
#the target's weapon's graze modifier is = 4
#player dodge threshold is = 8
#player's modified dodge threshold is = 4
#the target deals this much damage to player = 1

#player rolled average, got 1 damage through
#enemy rolled average, dodge almost eclipsed the play'er damage, but graze alloed the enemy to get 1 damage through
# may want to give daggers another die or increase to d4s


#original arrays: 
#player attacker dice array: [2, 3, 2, 1, 2] player defender dice array: [3, 1, 2, 2, 3]
#target defender dice array: [2, 1, 2, 2]target attacker dice array: [1, 4, 2]
#after combat results: 
#player attacker dice array: [3] player defender dice array: [2, 3, 3]
#target defender dice array: []target attacker dice array: [4]
#----------------
#attack damage dealt from player to target: 
#sum of player attack dice = 3
#the player's weapon's graze modifier is = 0
#target dodge threshold is = 1
#the player deals this much damage target = 2
#----------------
#attack damage dealt from target to player: 
#sum of player attack dice = 4
#the target's weapon's graze modifier is = 4
#player dodge threshold is = 8
#player's modified dodge threshold is = 4
#the target deals this much damage to player = 0


#original arrays: 
#player attacker dice array: [2, 2, 2, 2, 1] player defender dice array: [2, 3, 2, 1, 2]
#target defender dice array: [2, 3, 1, 2]target attacker dice array: [2, 2, 7]
#after combat results: 
#player attacker dice array: [2] player defender dice array: [1, 2, 3]
#target defender dice array: []target attacker dice array: [7]
#----------------
#attack damage dealt from player to target: 
#sum of player attack dice = 2
#the player's weapon's graze modifier is = 0
#target dodge threshold is = 1
#the player deals this much damage target = 1
#----------------
#attack damage dealt from target to player: 
#sum of player attack dice = 7
#the target's weapon's graze modifier is = 4
#player dodge threshold is = 8
#player's modified dodge threshold is = 4
#the target deals this much damage to player = 3

 
#original arrays: 
#player attacker dice array: [3, 3, 1, 2, 1] player defender dice array: [3, 2, 1, 1, 1]
#target defender dice array: [1, 1, 3, 2]target attacker dice array: [2, 4, 8]
#after combat results: 
#player attacker dice array: [3] player defender dice array: [1, 1, 1, 3]
#target defender dice array: []target attacker dice array: [8, 4]
#----------------
#attack damage dealt from player to target: 
#sum of player attack dice = 3
#the player's weapon's graze modifier is = 0
#target dodge threshold is = 1
#the player deals this much damage target = 2
#----------------
#attack damage dealt from target to player: 
#sum of player attack dice = 12
#the target's weapon's graze modifier is = 4
#player dodge threshold is = 8
#the target deals this much damage to player = 4
#perk idea: dice not used to block and attack add to your dodge bonus. good for low armor builds


