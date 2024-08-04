extends HBoxContainer

class_name SkillsContainer


@onready var selected_skill_label = $MarginContainer9/PanelContainer2/VBoxContainer/SelectedSkillLabel as Label
@onready var selected_skill_rich_text_label = $MarginContainer9/PanelContainer2/VBoxContainer/SelectedSkillRichTextLabel as RichTextLabel


var SkilLDescriptions #TODO move to resource file
#TODO make this its own scene

# Called when the node enters the scene tree for the first time.
func _ready():
	var vitality_skills: Array = get_tree().get_nodes_in_group("skill_name")
	for node: Label in vitality_skills:
		node.connect("mouse_entered",Callable(self,"update_selected_skill_title").bind(node))
		#TODO finish connecting all skills
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_selected_skill_title(input_label: Label) -> void:
	selected_skill_label.set_text(input_label.get_text())
	
	
