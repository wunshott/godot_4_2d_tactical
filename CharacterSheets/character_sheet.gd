extends Resource

class_name CharacterSheet

signal HP_changed
signal DT_changed
signal stamina_changed
signal limb_hp_changed
signal player_died
signal placeholder
signal max_stamina_changed
signal max_HP_changed

## Skills

## Perk List
@export var Perklist: Array[String] # list the text string of perks

## Stats
@export var VITALITY: int #BODYBUILDER
@export var COORDINATION: int #BALLERINA
@export var ELOQUENCE: int  #POLITICIAN
@export var INTUITION: int #LIBRARIAN/SAVANT
@export var BRILLIANCE: int #SOCIOPATH
@export var EMPATHY: int #GURU

@export var stat_average: int = 5 #Number used to compute stat bonuses. Maybe this number can change based on perks?

@export var equipped_weapon_dictionary: Dictionary = {
	"right_arm": Weapon,
	"left_arm": Weapon,
}

@export var equipped_armor_dictionary: Dictionary = {
	"head": Armor,
	"torso":Armor,
	"right_arm": Armor,
	"left_arm": Armor,
	"right_leg": Armor,
	"left_leg": Armor,
	"left_foot": Armor,
	"right_foot": Armor,
	"necklace": Item,
	"rings": "placeholder", #TODO update with slots
}

#have a check that says if the stat is too low, too high. you get a perk

##Limb Health
#sets the health/dice pools for each limb. TODO add a way to reference class dice. maybe classes change how each max_HP dice is defined?
var max_head_hp: int = BRILLIANCE/2 + EMPATHY/2 + INTUITION/2 + .5*VITALITY
var head_hp: int #= clampi(0,0,max_head_hp) not clamping these values so they can increase based on bonuses

var max_torso_hp: int = VITALITY
var torso_hp: int #= clampi(0,0,max_torso_hp)

var max_right_arm_hp: int = VITALITY/2 + COORDINATION/2
var right_arm_hp:int# = clampi(0,0,max_right_arm_hp)

var max_left_arm_hp: int = VITALITY/2  + COORDINATION/2
var left_arm_hp: int #= clampi(0,0,max_left_arm_hp)

var max_right_leg_hp: int = VITALITY/2 + COORDINATION/2
var right_leg_hp: int #= clampi(0,0,max_right_leg_hp)

var max_left_leg_hp: int = VITALITY/2  + COORDINATION/2
var left_leg_hp: int #= clampi(0,0,max_left_leg_hp)


var dt_stamina_fraction: float = .5

var limb_dictionary: Dictionary = {
	"head":[head_hp,max_head_hp],
	"torso":[torso_hp,max_torso_hp],
	"right_arm": [right_arm_hp,max_right_arm_hp],
	"left_arm": [left_arm_hp,max_left_arm_hp],
	"right_leg": [right_leg_hp,max_right_leg_hp],
	"left_leg": [left_leg_hp,max_left_leg_hp],
}

var max_dodge_dice: int = 15 #abritrary limit on dodge dice limit

## Character HP/DT
#These variables track the players health and damage threshold (DT). If DT = HP, the player dies
var max_HP: int:  get = get_max_HP #, set = set_max_HP,
var HP: int:get = get_HP #,set = set_HP #TODO no setter because hp is set by limb hp set = set_hp,
var DT: int: set = set_DT, get = get_DT #Death threshold


## Stamina
#used to add effort to attacks
var max_stamina: int: set = set_max_stamina, get = get_max_stamina
var stamina: int: set = set_stamina, get = get_stamina

## Derived Stats/Skill
var dodge_dice: int: set = set_dodge_dice, get = get_dodge_dice

func set_dodge_dice(value: int) -> void:
	dodge_dice = clampi(value,0,max_dodge_dice)

func get_dodge_dice() -> int:
	return dodge_dice



## Set/get Stat Functions
#These functions set/get their value and emit a signal. the resource file will emit a signal so everything that holds it (hud, char) will update accordingly
#HP
	

func set_max_HP() -> void:
	#var placeholder_max_HP: int = VITALITY*3
	var temp_max_HP_count: int
	for limb_max_hp in limb_dictionary.values(): # each limb will call this function to change the HP
		temp_max_HP_count += limb_max_hp[1]
	max_HP = clamp(temp_max_HP_count,0,temp_max_HP_count) #TODO should this be a function of limb max hp?
	max_HP_changed.emit(max_HP)
	

func get_max_HP() -> int:
	return max_HP

func set_HP() -> void:
	var temp_hp_count = 0 
	for limb_hp in limb_dictionary.values(): # each limb will call this function to change the HP
		temp_hp_count += limb_hp[0] #first element is the curent hp, 2nd is the max
	HP = clamp(temp_hp_count,0,get_max_HP())
	HP_changed.emit(HP)
	
	if get_DT() >= HP:
		player_died.emit()
	
func get_HP() -> int:
	return HP
	

#DT
func set_DT(value: int):
	DT = clamp(value,0,get_max_HP())  #+ 40% of max stamina #MAX DT should be equal to max HP
	DT_changed.emit(DT)
	if DT >= get_HP():
		player_died.emit()

func get_DT() -> int:
	return DT
	
func increase_dt(value: int) -> void:
	set_DT(get_DT() + value)


# Limb HP and dice pool #TODO add a dice pool function
#TODO add visible health bars for the limbs
func initialize_limbs_HP() -> void:
	for limb in limb_dictionary:
		set_max_limb_HP(limb)
		set_limb_hp(limb, get_max_limb_HP(limb))
	set_max_HP()
	set_HP()

func damamge_limb(limb: String, value: int) -> void:
	set_limb_hp(limb,get_limb_hp(limb)- value)

func set_max_limb_HP(limb: String) -> void:
	if limb == "head":
		limb_dictionary[limb][1] = BRILLIANCE/2 + EMPATHY/2 + INTUITION/2 + .5*VITALITY
	elif limb == "torso":
		limb_dictionary[limb][1] = VITALITY*1.5
	elif limb == "right_arm" or "left_arm" or "left_leg" or "right_leg": # all limbs are the same
		limb_dictionary[limb][1] = VITALITY/2 + COORDINATION/2
	
		
func get_max_limb_HP(limb: String) -> int:
	return limb_dictionary[limb][1]

func set_limb_hp(limb: String, value: int) -> void:
	limb_dictionary[limb][0] = value
	limb_hp_changed.emit(value) #dice pool changes with hp
	set_HP()
	#hp will calculate the health of all limbs
	
func get_limb_hp(limb: String) -> Variant:
	if limb_dictionary.has(limb):
		return limb_dictionary[limb][0]
	else:
		print("limb/key not found in dictionary: ", limb)
		return null

func get_stat_bonus(stat_name: int) -> int: #computes the stat bonus. current - 5. can be a negative value
	var stat_bonus = stat_name - stat_average
	return stat_bonus
	
##Stamina set/gets
 #TODO add a dice pool function
func set_max_stamina(value: int) -> void:
	max_stamina = clamp(value,0,VITALITY*2 + (get_stat_bonus(VITALITY)))
	max_stamina_changed.emit(max_stamina)

func get_max_stamina() -> int:
	return max_stamina

# stamina and dice pool  #TODO add a dice pool function
func set_stamina(value: int) -> void:
	stamina = clamp(value,0,get_max_stamina())
	set_DT(get_max_HP() * dt_stamina_fraction - get_stamina())
	stamina_changed.emit(stamina) #dice pool changes with stamina
	
	if stamina == 0:
		placeholder.emit() #placeholder signal
	
func get_stamina() -> int:
	return stamina
	
func remove_stamina(value: int) -> void:
	set_stamina(get_stamina() - value)

	
func replenish_stamina(value: int) -> void:
	set_stamina(get_stamina() + value)


