extends VBoxContainer

class_name StatsContainer



@onready var ui = $"../../.." as UI


@onready var selected_stat_detail = $HBoxContainer/SelectedStatDetail as SelectedStatMenu



@onready var stat_title_label = $HBoxContainer/SelectedStatDetail/VBoxContainer/StatTitleLabel as Label

@onready var StatDescriptionRTL = $HBoxContainer/SelectedStatDetail/VBoxContainer/StatDescriptionRTL as RichTextLabel

@onready var each_bonus_rtl = $HBoxContainer/SelectedStatDetail/VBoxContainer/VBoxContainer/EachBonusRTL as RichTextLabel
@onready var equation_rtl = $HBoxContainer/SelectedStatDetail/VBoxContainer/VBoxContainer/EquationRTL as RichTextLabel
@onready var total_rtl = $HBoxContainer/SelectedStatDetail/VBoxContainer/VBoxContainer/TotalRTL as RichTextLabel


@onready var vitality_label = $HBoxContainer/VBoxContainer/MarginContainer/PrimaryStatContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/HBoxContainer/MarginContainer/VitalityLabel as Label
@onready var coordination_label = $HBoxContainer/VBoxContainer/MarginContainer/PrimaryStatContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer2/HBoxContainer/MarginContainer/CoordinationLabel as Label
@onready var eloquence_label = $HBoxContainer/VBoxContainer/MarginContainer/PrimaryStatContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer3/HBoxContainer/MarginContainer/EloquenceLabel as Label
@onready var brilliance_label = $HBoxContainer/VBoxContainer/MarginContainer/PrimaryStatContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer4/HBoxContainer/MarginContainer/BrillianceLabel as Label
@onready var intuition_label = $HBoxContainer/VBoxContainer/MarginContainer/PrimaryStatContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer5/HBoxContainer/MarginContainer/IntuitionLabel as Label
@onready var empathy_label = $HBoxContainer/VBoxContainer/MarginContainer/PrimaryStatContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer6/HBoxContainer/MarginContainer/EmpathyLabel as Label

#TODO make this a solo scene to re-use (character create/ normal ui)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_connect_stat_description_box()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize_stats() -> void:
	vitality_label.set_text(str(ui.player_character_data._get_stat("Vitality")))
	coordination_label.set_text(str(ui.player_character_data._get_stat("Coordination")))
	eloquence_label.set_text(str(ui.player_character_data._get_stat("Eloquence")))
	brilliance_label.set_text(str(ui.player_character_data._get_stat("Brilliance")))
	intuition_label.set_text(str(ui.player_character_data._get_stat("Intuition")))
	empathy_label.set_text(str(ui.player_character_data._get_stat("Empathy")))


func _connect_stat_description_box() -> void:
	var stat_labels = get_tree().get_nodes_in_group("stat_name")
	for node:Label in stat_labels:
		node.connect("mouse_entered",Callable(self,"_fill_stat_description_box").bind(node.get_text()))
		
	return
	
func _fill_stat_description_box(stat_name: String, stat_description: String = "", stat_equation: String = "", stat_total:int = 0) -> void:
	
	
	if stat_name == "Vitality":
		selected_stat_detail.stat_displayed = selected_stat_detail.StatDisplayed.Vitality
		stat_title_label.set_text(selected_stat_detail.VitalityDictionary[ui.player_character_data._get_stat(stat_name)])
	elif stat_name == "Coordination":
		selected_stat_detail.stat_displayed = selected_stat_detail.StatDisplayed.Coordination
		stat_title_label.set_text(selected_stat_detail.CoordinationDictionary[ui.player_character_data._get_stat(stat_name)])
	elif stat_name == "Eloquence":
		selected_stat_detail.stat_displayed = selected_stat_detail.StatDisplayed.Eloquence
		stat_title_label.set_text(selected_stat_detail.EloquenceDictionary[ui.player_character_data._get_stat(stat_name)])
	elif stat_name == "Brilliance":
		selected_stat_detail.stat_displayed = selected_stat_detail.StatDisplayed.Brilliance
		stat_title_label.set_text(selected_stat_detail.BrillianceDictionary[ui.player_character_data._get_stat(stat_name)])
	elif stat_name == "Intuition":
		selected_stat_detail.stat_displayed = selected_stat_detail.StatDisplayed.Intuition
		stat_title_label.set_text(selected_stat_detail.IntuitionDictionary[ui.player_character_data._get_stat(stat_name)])
	elif stat_name == "Empathy":
		selected_stat_detail.stat_displayed = selected_stat_detail.StatDisplayed.Empathy
		stat_title_label.set_text(selected_stat_detail.EmpathyDictionary[ui.player_character_data._get_stat(stat_name)])
	else:
		print_debug("no stat")
	
	selected_stat_detail.display_stat(ui.player_character_data._get_stat(stat_name))


func _on_ui_ready():
	initialize_stats()
