extends Resource

class_name Action


#do weapons have attacks inside them?

@export var action_name: String

#damage variables
@export_enum("bludgeoning","piercing","slashing","none") var damage_type: int
#@export var damage_type: String #bludgeoning, piercing, slashing, etc

@export var attack_type: ATTACK_TYPE
enum ATTACK_TYPE {
	Attack,
	Defend, 
	Fakeout,
	etc,
}

@export var explode_number:int #TODO. add a dice explosion mechanic
#TODO move all dice roll functions to this resource or to a singleton?
@export var win_conditions: Array[int]

#stamina cost
@export var cost_stamina: bool #does the action require stamina
@export var min_stamina_dice_cost: int #how much stamina the action costs


#additional effect checks
@export var elemental_damage: bool #if this action does elemental
@export var additional_effect: Array #bleed, etc

#AOE
@export var aoe_shape: String #circle,cone,square
@export var aoe_range: int #radius/length of the aoe attack

#range variables
@export var adjacent_targets_only: bool #can this attack only hit adjacent tiles
@export var tile_range: int #how far can this attack reach
@export var diagonal_attack: bool #can this attack hit targets diagonally of the player

#burns resource
@export var ammo_consumed: int

#flavor text describing the action
@export var damage_description: String #flavor text for the player
@export var mechanical_description: String #explicit text that describes which dice are rolled

#injury modifiers
@export var injury_modifiers: Array[String] #which parts of the injurt table do this action modify
#example, weapon has increased chance to bleed


#misc bonuses
@export var placeholder_bonus_variable: Array

#which limbs can the attack hit?
@export var can_hit_all_limbs: bool
@export var limbs_can_hit: Array[String]

#TODO figure out a way to have attacks reference an attack pattern

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _damage(Target: Node, damage_type: String, damage_amount: int) -> void:
	Target.take_damage(damage_type,damage_amount)
	
