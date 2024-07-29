extends Resource

class_name Item

@export var ItemName: String
@export var ItemSize: String
@export var ItemSprite: Texture2D
@export var Equip_Slot: String  #possible limbs this item can be equipped with
@export var currently_equipped_slot: String
#right/left limbs are combined

#enum currently_equipped_slot_enum {hands, torso, head, waist, feet, legs, arms} #TODO replace equip_slot with this enum
#@export var currently_equipped_slot: currently_equipped_slot_enum #TODO replace equip_slot with this enum

@export var allowed_equip_slots: Array[String]

@export var ItemDescription: String
@export var ItemLore: String #TODO have the history update. rich text append? make it a richtextlabel?
@export var HiddenItemLore: String  #TODO have the history update. rich text append? make it a richtextlabel?
