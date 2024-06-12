extends Control

@onready var armor_hp_bar = $Panel/HBoxContainer/ArmorHpBar


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_equipment_panel_equip_item_to_player(limb, ItemToEquip):
	armor_hp_bar.set_max(ItemToEquip.max_armor_hp) #assigns the max value based on the armor_max_hp
	armor_hp_bar.set_value(ItemToEquip.armor_hp)  #assigns the value based on the current armor's hp. need to update this whenever damage is taken
	#ItemToEquip.connect("test",Callable(self,"_update_armor_hp")) #TODO connects the resource to the node
	

func _update_armor_hp(armor: Armor) -> void:
	armor_hp_bar.set_value(armor.armor_hp) #HACK quick workaround, fix 
	return


func _on_stats_armor_damaged(damage, armor):
	_update_armor_hp(armor)
