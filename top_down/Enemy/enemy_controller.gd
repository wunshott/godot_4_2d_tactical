extends Node


signal attack_signal(attack_action:Action, THC: int, target_limb: String)

@onready var sprite_2d = $"../Sprite2D"
@onready var inventory = $"../Inventory"
@onready var stats = $"../Stats"



var player_position = Vector2.ZERO
var targeted_limb: String
var current_attack_action: Action


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#when end turn button ends, the enemy should do their move

#attack move:
#player should snap towards player and snap away
#enemy should choose a limb
#enemy should ensure weapon is equipped
#enemy should attack the chosen limb

func _attack_tween_animation() -> void:
	var original_position = sprite_2d.get_global_position() 
	#TODO change function to move to 
	var tween = create_tween()

	tween.tween_property(sprite_2d, "global_position",  player_position,.1)
	tween.tween_property(sprite_2d, "global_position", original_position,.1)
	
#move next to player
#astar grid
#find closest adjacent tile to player
#move to it


func _on_end_turn_pressed():
	_attack_tween_animation()
	
	#TODO put all attacking into a function
	#TODO remove stamina for attacking
	var base_hit_chance = stats._get_hit_chance()
	_choose_limb()
	Dice_Roller._enemy_roll_to_attack(_get_attack_from_weapon(), base_hit_chance,targeted_limb)
	


func _on_player_player_position(position: Vector2):
	player_position = position

func _get_attack_from_weapon() -> Action:
	#TODO code to decide which action from weapon to pick in this moment
	var selected_attack: Action = inventory.equipped_weapon_dict["RightHand"].Attacks[0]
	stats._set_stamina_pool(stats._get_stamina_pool() - selected_attack.stamina_cost ) #TODO reduce the enemies stamina in a cleaner way
	return selected_attack


func _choose_limb() -> void:
	#picks the lowest armor limb?
	#picks the head for nwo
	targeted_limb = "Head"
