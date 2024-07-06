extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered",Callable(self,"_on_area_entered"))
	self.connect("area_exited",Callable(self,"_on_area_exited"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area: Area2D):
	area.add_to_group("Attack")



func _on_area_exited(area: Area2D):
	area.remove_from_group("Attack")
