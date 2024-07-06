extends Button

@export var panel_container: PanelContainer

# Called when the node enters the scene tree for the first time.
var is_skill_menu_visible: bool = false

func _ready():
	#combatant_class.connect("HP_changed",Callable(test_hp_dt_bar,"on_stats_set_HP"))
	self.connect("pressed",Callable(self,"toggle_skill_visibility"))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func toggle_skill_visibility() -> void:
	is_skill_menu_visible = !is_skill_menu_visible
	panel_container.set_visible(is_skill_menu_visible)
