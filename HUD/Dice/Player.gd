extends HBoxContainer

class_name PlayerRoller



@export var combatant_class: Class
@export var typed_dice_array: Array[int] 

@onready var reset_dice = $"../ResetDice" as Button

@onready var arm_dice_pool: ArmDiceContainer = $VBoxContainer/ArmDice
@onready var attack_dice_pool: AttackDiceContainer = $VBoxContainer2/AttackDicePool
@onready var defense_dice_pool: DefenseDiceContainer = $VBoxContainer3/DefenseDice
@onready var limb_selector = $LimbSelector as OptionButton

@onready var left_weapon_dice = $VBoxContainer/HBoxContainer2/VBoxContainer/LeftWeaponDice as WeaponDiceContainer
@onready var right_weapon_dice = $VBoxContainer/HBoxContainer2/VBoxContainer2/RightWeaponDice as WeaponDiceContainer
@onready var stamina_dice = $VBoxContainer/StaminaDice as StaminaDiceContainer
 
@onready var test_hp_dt_bar = $VBoxContainer/HBoxContainer/test_hp_dt_bar as HPDTBar


@onready var dodge_label = $VBoxContainer/DodgeLabel as Label

var targeted_limb: String


# Called when the node enters the scene tree for the first time.
func _ready():
	combatant_class.connect("HP_changed",Callable(test_hp_dt_bar,"on_stats_set_HP"))
	combatant_class.connect("Dodge_changed",Callable(self,"on_dodge_changed"))
	combatant_class.connect("DT_changed",Callable(test_hp_dt_bar,"on_stats_set_DT"))
	
	reset_dice.connect("pressed",Callable(self,"_on_reset_dice_pressed"))
	
	
	_initialize_hp() 
	test_hp_dt_bar.hp_bar.set_max(combatant_class.get_HP())
	test_hp_dt_bar.hp_bar.set_value(combatant_class.get_HP())
	
	test_hp_dt_bar.dt_bar.set_max(combatant_class.get_HP())
	
	pool_arm_dice_to_arm_container()
	pool_dice_to_weapon_container()
	pool_stamina_dice_to_container()
	#pool_typed_dice_to_arm_container()
	#add_items()
	connect_dropdown_selector_to_target_limb()
	
func add_items(combatant: PlayerRoller) -> void: #makes the combatant grab the other's limb
	for limbs in combatant.combatant_class.limb_dictionary.keys(): #grab from the target class, not your own
		combatant.limb_selector.add_item(limbs)



func pool_stamina_dice_to_container() -> void:
	for stamina in range(combatant_class.get_stamina()):
		stamina_dice.DiceArray.append(6)
		
	stamina_dice.create_dice_array()
	
func update_stamina_pool_in_container() -> void: #removes stamina dice as the torso is damaged
	var current_stamina: int = combatant_class.get_stamina()
	var stamina_before_attacked: int = stamina_dice.get_child(0).get_child_count()
	if current_stamina > 0:
		for idx in range(stamina_before_attacked - current_stamina):
			stamina_dice.DiceArray.pop_front() #deletes element from the array
			stamina_dice.get_child(0).get_child(idx).queue_free()

func pool_typed_dice_to_arm_container() -> void:
	arm_dice_pool.DiceArray.append_array(typed_dice_array)
	arm_dice_pool.create_dice_array()

func pool_dice_to_weapon_container() -> void:
	left_weapon_dice.DiceArray.append_array(combatant_class.equipped_left_arm_weapon.weapon_hit_die)
	left_weapon_dice.create_dice_array()
	
	right_weapon_dice.DiceArray.append_array(combatant_class.equipped_right_arm_weapon.weapon_hit_die)
	right_weapon_dice.create_dice_array()
	

func pool_arm_dice_to_arm_container() -> void:
	arm_dice_pool.DiceArray.append_array(combatant_class.limb_dictionary["left_arm"])
	arm_dice_pool.DiceArray.append_array(combatant_class.limb_dictionary["right_arm"])
	arm_dice_pool.create_dice_array()



func connect_dropdown_selector_to_target_limb() -> void:
	limb_selector.connect("item_selected",Callable(self,"set_targeted_limb"))

func set_targeted_limb(limb_dropdown_idx: int) -> void:
	targeted_limb = limb_selector.get_item_text(limb_dropdown_idx)
	#print(limb_selector.get_item_text(limb_dropdown_idx))

func _initialize_hp() -> void:
	combatant_class.initialize_limb_hp()
	combatant_class.set_HP()
	combatant_class.set_max_HP()
	combatant_class.set_dodge_dice(combatant_class.COORDINATION)
	combatant_class.set_dodge()
	combatant_class.set_stamina_dice( combatant_class.VITALITY )
	combatant_class.set_stamina()
	combatant_class.set_hard_DT(0)
	combatant_class.set_DT()
	

func on_dodge_changed() -> void:
	dodge_label.set_text("Dodge:" + str(combatant_class.get_dodge()))

func _on_reset_dice_pressed():
	#delete all the children dice
	for children in attack_dice_pool.get_child(0).get_children():
		children.queue_free()
	for children in defense_dice_pool.get_child(0).get_children():
		children.queue_free()
	for children in arm_dice_pool.get_child(0).get_children():
		children.queue_free()
	for children in left_weapon_dice.get_child(0).get_children():
		children.queue_free()
	for children in right_weapon_dice.get_child(0).get_children():
		children.queue_free()
	
	arm_dice_pool.DiceArray.clear()
	left_weapon_dice.DiceArray.clear()
	right_weapon_dice.DiceArray.clear()
	pool_arm_dice_to_arm_container()
	pool_dice_to_weapon_container()
	
	#^ call these functions
	# clear out their arm array,
	# recall the functions to populate with current vallues
	
	#player_hp.set_max(player_class.get_max_HP())
	#player_hp.set_value(player_class.get_HP())
	#play_hp_label.set_text(str(player_class.get_HP()))
