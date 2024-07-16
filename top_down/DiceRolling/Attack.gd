extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered",Callable(self,"_on_body_entered"))
	self.connect("body_exited",Callable(self,"_on_body_exited"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body: Node2D):
	body.add_to_group("Attack")
	body.die_graphic.set_self_modulate(Color.RED)



func _on_body_exited(body: Node2D):
	body.remove_from_group("Attack")
	body.die_graphic.reset_modulation()
