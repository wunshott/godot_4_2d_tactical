extends HBoxContainer

class_name AttackList

signal attack_button_pressed(AttackResource,HitChance)

@onready var damage_type_label = $DamageType/HBoxContainer/DamageTypeLabel
@onready var armor_damage_label = $ArmorDamage/HBoxContainer/ArmorDamageLabel
@onready var stamina_damage_label = $StaminaDamage/HBoxContainer/StaminaDamageLabel
@onready var stamina_cost_label = $StaminaCost/HBoxContainer/StaminaCostLabel
@onready var range_label = $Range/HBoxContainer/RangeLabel
@onready var hit_chance_label = $HitChance/HBoxContainer/HitChanceLabel


@onready var attack_button = $AttackButton
@onready var attack_name = $AttackName


var current_total_hit_bonus: int
var attack_resource: Action #assigned by dice_roller
var current_player_stamina: int


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("attack_button_pressed",Callable(Dice_Roller,"_on_get_player_action"))
	#attack_button.set_texture()# update the button texture with the weapon, even later update each action to have a sprite
	pass # Replace with function body.

# ensure the attack cost is properly translated to the attack menu


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attack_button_pressed():
		attack_button_pressed.emit(attack_resource,current_total_hit_bonus)
		
