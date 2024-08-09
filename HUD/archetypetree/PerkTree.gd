extends PanelContainer

class_name PerkTree


@export var desire_container_1: HBoxContainer
@export var desire_container_2: HBoxContainer


# perkname has an array of perks
# generate a new perk node and assign the perk resource


func _ready() -> void:
	_connect_desire_buttons()

func _connect_desire_buttons() -> void:
	for child: DesireButton in desire_container_1.get_children():
		child.connect("toggled",Callable(self,"_on_perk_button_toggled").bind(child.DesireName))
	for child: DesireButton in desire_container_2.get_children():
		child.connect("toggled",Callable(self,"_on_perk_button_toggled").bind(child.DesireName))


func _on_perk_button_toggled(toggled_on: bool, desire_name: String):
	if toggled_on:
		return
	else:
		return

#TODO the desiretree panel should be 1 node. clicking each button will swap the perks shown. make the trees simpler
# number of trees = #vbox containers
# gives perks a level to decide their place in the trees. perks can have the same parent, but branch into a different hbox
