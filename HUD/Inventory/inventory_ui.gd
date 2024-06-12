extends Control


@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var inventory_passed_from_player: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	#connectSlots()
	pass # Replace with function body.
	

#func connectSlots():
	#for slot in slots:
		#var callable = Callable(onSlotClicked) # this allows you to bind inputs to button press signals
		#callable = callable.bind(slot)
		#slot.pressed.connect(callable)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update() -> void:
	for i in min(inventory_passed_from_player.size(), slots.size()):
		slots[i].update(inventory_passed_from_player[i])
	
	inventory_passed_from_player.clear()

func onSlotClicked(slot):
	pass
	#TODO TRY RADIAL ARMOR BARS
	#TODO CHECK ANAND NOTES ON THE SUBJECT
