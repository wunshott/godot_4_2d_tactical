extends Node



@export var d20_dice_size: int
@export var d6_dice_size: int

#var d20_rng = RandomNumberGenerator.new()

@onready var injury_table = $InjuryTable


var is_attack_loaded: bool = false
var loaded_attack_die: int

#click button
#load player action and dice
#click rightclick or click enemy to pull up vats
#click the limb
#grab enemy AC, defense dice
#TODO roll the dice

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func roll_skill_check():
	#TODO fill with rolls for skill checks
	return

func load_in_attack(all_attacker_dice: int) -> void:
	is_attack_loaded = true #TODO add a way to cancel the attack (Hitting escape, swapping the weapon, right click)
	# when the attack button is pushed
	# this function preps the current action
	# once the limb is clicked, attack and defend die are rolled
	loaded_attack_die = all_attacker_dice
	print("select a limb to target")
	

func roll_attack() -> void:
	if is_attack_loaded == true:
		var dice_outcome: Array
		for dice in loaded_attack_die:
			dice_outcome.append(randi_range(1,d6_dice_size))
		print("attaker dice = " + str(dice_outcome))
		
		is_attack_loaded = false #reset the loaded attack after using it
	else:
		print("attack is not loaded")
	
	

func roll_defend(defender_dodge_dice: int, defender_block_dice: int) -> void:
	var total_defender_dice: int = defender_dodge_dice + defender_block_dice
	if is_attack_loaded == false:
		print("select an attack")
		return
	else:
		var dice_outcome: Array
		for dice in total_defender_dice:
			dice_outcome.append(randi_range(1,d6_dice_size))
		roll_attack()
		print("defender dice = " + str(dice_outcome))


#you decide how to split the dice between attack and defense
# armor must be used for defense (both parties)
# both parties roll their dice, they decide how many attack and defense dice
#compare the A group and D group

func attack_picks() -> void:
	return
	
func defender_picks() -> void:
	return
	
func warhammer_outcome() -> void:
	return
	
func colin_outcome() -> void:
	
	#Attack rolls however many dice
#Defense rolls however many dice

#Defender gets to match their defense dice to the attackers dice

#Any attacker dice over the defender dice is a damage that gets through
	return
