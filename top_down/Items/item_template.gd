extends Resource

class_name Item

@export var ItemName: String
@export var ItemSize: String
@export var ItemSprite: Texture2D
@export var Equip_Slot: String  #possible limbs this item can be equipped with
#right/left limbs are combined

@export var ItemDescription: String
@export var ItemLore: String #TODO have the history update. rich text append? make it a richtextlabel?
@export var HiddenItemLore: String  #TODO have the history update. rich text append? make it a richtextlabel?
