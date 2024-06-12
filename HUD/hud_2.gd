extends Control
class_name HUD

signal recieved_char_sheet_from_player
signal recieved_char_sheet_from_target

@export var CharacterSheetData: CharacterSheet
@export var TargetSheetData: CharacterSheet

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_send_char_sheet_to_hud(CharacterSheetDataFromPlayer: CharacterSheet):
	CharacterSheetData = CharacterSheetDataFromPlayer
	recieved_char_sheet_from_player.emit()


func _on_enemy_send_char_sheet_to_vats(CharacterSheetDataFromTarget: CharacterSheet):
	TargetSheetData = CharacterSheetDataFromTarget
	recieved_char_sheet_from_target.emit()
