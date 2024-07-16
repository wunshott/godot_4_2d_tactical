extends AnimatedSprite2D

@onready var default_modulate: Color = self.modulate

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func random_frame() -> void:
	var last_frame = frame
	while frame == last_frame:
		frame = randi() % sprite_frames.get_frame_count("roll")



func reset_modulation() -> void:
	set_self_modulate(default_modulate)
