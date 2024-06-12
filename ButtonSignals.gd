extends Node

@onready var node: TestBattle = $".."

@onready var target_head = $"../Buttons/PlayerButtons/TargetHead"
@onready var target_torso = $"../Buttons/PlayerButtons/TargetTorso"
@onready var target_right_arm = $"../Buttons/PlayerButtons/TargetRightArm"
@onready var target_left_arm = $"../Buttons/PlayerButtons/TargetLeftArm"
@onready var target_left_leg = $"../Buttons/PlayerButtons/TargetLeftLeg"
@onready var target_right_leg = $"../Buttons/PlayerButtons/TargetRightLeg"

@onready var player_head = $"../Buttons/EnemyButtons/PlayerHead"
@onready var player_torso = $"../Buttons/EnemyButtons/PlayerTorso"
@onready var player_right_arm = $"../Buttons/EnemyButtons/PlayerRightArm"
@onready var player_left_arm = $"../Buttons/EnemyButtons/PlayerLeftArm"
@onready var player_left_leg = $"../Buttons/EnemyButtons/PlayerLeftLeg"
@onready var player_right_leg = $"../Buttons/EnemyButtons/PlayerRightLeg"

@onready var player_buttons = $"../Buttons/PlayerButtons"
@onready var enemy_buttons = $"../Buttons/EnemyButtons"

var PlayerTargetLimb: String
var EnemyTargetLimb: String

var PlayerLimbDict: Dictionary
var EnemyLimbDict: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func enable_signals() -> void:
	for idx in self.get_children():
		idx.set_process_mode(0)

	

func disable_signals() -> void:
	for idx in self.get_children():
		idx.set_process_mode(4)


func _on_target_head_pressed():
	PlayerTargetLimb = "head"
	print(node.enemy_class.limb_dictionary[PlayerTargetLimb])


func _on_target_torso_pressed():
	PlayerTargetLimb = "torso"
	print(node.enemy_class.limb_dictionary[PlayerTargetLimb])
func _on_target_right_arm_pressed():
	PlayerTargetLimb = "right_arm"
	print(node.enemy_class.limb_dictionary[PlayerTargetLimb])

func _on_target_left_arm_pressed():
	PlayerTargetLimb = "left_arm"
	print(node.enemy_class.limb_dictionary[PlayerTargetLimb])

func _on_target_left_leg_pressed():
	PlayerTargetLimb = "left_leg"
	print(node.enemy_class.limb_dictionary[PlayerTargetLimb])

func _on_target_right_leg_pressed():
	PlayerTargetLimb = "right_leg"
	print(node.enemy_class.limb_dictionary[PlayerTargetLimb])
###########

func _on_player_head_pressed():
	EnemyTargetLimb = "head"
	print(node.player_class.limb_dictionary[EnemyTargetLimb])
	
func _on_player_torso_pressed():
	EnemyTargetLimb = "torso"
	print(node.player_class.limb_dictionary[EnemyTargetLimb])

func _on_player_right_arm_pressed():
	EnemyTargetLimb = "right_arm"
	print(node.player_class.limb_dictionary[EnemyTargetLimb])

func _on_player_left_arm_pressed():
	EnemyTargetLimb = "left_arm"
	print(node.player_class.limb_dictionary[EnemyTargetLimb])

func _on_player_left_leg_pressed():
	EnemyTargetLimb = "left_leg"
	print(node.player_class.limb_dictionary[EnemyTargetLimb])

func _on_player_right_leg_pressed():
	EnemyTargetLimb = "right_leg"
	print(node.player_class.limb_dictionary[EnemyTargetLimb])

func _on_fight_pressed():
	if PlayerTargetLimb and EnemyTargetLimb:
		print("player attacks enemy's " + str(PlayerTargetLimb))
		print("enemy attacks player's " + str(EnemyTargetLimb))
		node.combat_dice_trade_hp_pool_with_classes_full_limb_button(PlayerTargetLimb,node.enemy_class.limb_dictionary,EnemyTargetLimb,node.player_class.limb_dictionary)
	
	else:
		print(node.enemy_class.limb_dictionary)
		print("need to select a target for player and enemy")


func _on_cancel_pressed():
	print(node.enemy_class.get_HP())
	node.enemy_class.focus_max_element(node.enemy_class.limb_dictionary["left_leg"],11)
	print(node.enemy_class.get_HP())
	EnemyTargetLimb = ""
	PlayerTargetLimb = ""
