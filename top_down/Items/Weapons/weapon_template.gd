extends Item


class_name Weapon

#@export var WeaponName: String = ""
@export var WeaponTtype: String = ""
#@export var WeaponIcon: Texture2D
@export var Attacks: Array[Action]
@export var currently_equipped_hand:String
@export var weapon_hit_die_amount: int #
