extends PanelContainer

class_name DieContainer

<<<<<<< Updated upstream
@export var Die: int
@onready var texture_rect = $TextureRect
@onready var dice = $Dice

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
=======
signal dice_rolled(dice_roll:int)
signal die_outcome_changed() #emitted whenever the dice value is changed from armor. prompts a recalc of the outcome array
@export var dice_max: int 


@export var die_graphic: AnimatedSprite2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var selected_die_gfx = $SelectedDieGfx as Sprite2D
@onready var gpu_particles_2d = $GPUParticles2D as GPUParticles2D



var dice_outcome: int
var is_selected: bool = false#: set = toggle_die_selection




# Called when the node enters the scene tree for the first time.
func _ready():
	update_dice_graphic(dice_max)
	animation_player.play("entering")

	
	
func set_die_gfx() -> int: 
	die_graphic.set_frame(dice_outcome-1)
	return dice_outcome
>>>>>>> Stashed changes

func update_dice_graphic(face_index:int) -> void:
	dice.frame = face_index
	return

<<<<<<< Updated upstream
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _get_drag_data(at_position: Vector2):
	#return Die #return the dice value
=======
func roll_die() -> void:
	if is_selected:
		dice_outcome = randi_range(1,dice_max) # where the actual dice roll happens
		dice_rolled.emit(dice_outcome)
		animation_player.play("roll")
		set_dice_selection(false)
	else: #dice is not selected, do not roll dice
		if !dice_outcome: #if there is no dice outcome, do nothing.
			return
		else: #spit out the latest dice outcome if its not rolled
			dice_rolled.emit(dice_outcome)
		return

func increase_die_number() -> void:
	if animation_player.is_playing():
		#if an animation is playing, do nothing. Would be nice to cancel that animation and move to the next one
		return
	#spin clockwise, increase dice
	if dice_outcome == dice_max: #can't increase the die any higher
		animation_player.play("decline_shake")
		return
	dice_outcome += 1
	die_outcome_changed.emit()
	animation_player.play("increase")
	

func decrease_die_number() -> void:
	if animation_player.is_playing():
		#if an animation is playing, do nothing. Would be nice to cancel that animation and move to the next one
		return
	#spin clockwise, increase dice
	if dice_outcome == 1: #can't lower the dice
		animation_player.play("decline_shake")
		return
	dice_outcome -= 1
	die_outcome_changed.emit()
	animation_player.play("decrease")

func decrease_frame() -> void:
	die_graphic.set_frame_and_progress(die_graphic.get_frame() - 1, 0.0)
	

#func _get_drag_data(_at_position: Vector2):
	#set_drag_preview(get_preview(dice.get_texture()))
	#return self
>>>>>>> Stashed changes
#
#func _can_drop_data(at_position: Vector2, data) -> bool:
	#return data is int 
#
#func _drop_data(at_position: Vector2, data): 
	#if data:
		#Die = data
		#update_dice_graphic(Die)
	#return

#func get_preview(item_dragged_texture: Texture2D):
	#return preview
<<<<<<< Updated upstream
=======


func _on_tree_exiting():
	animation_player.play("exiting")


func _on_selected_button_pressed(): #TODO replace with groups?
	is_selected = !is_selected
	selected_die_gfx.set_visible(!selected_die_gfx.is_visible())


func set_dice_selection(input_bool: bool) -> void:
	is_selected = input_bool
	selected_die_gfx.set_visible(input_bool)


func toggle_particle_emit() -> void:
	gpu_particles_2d.set_emitting(!gpu_particles_2d.is_emitting())

#func equal_to_winning_array(w_array: Array[int]) -> void:
	#for idx: int in w_array:
		#if dice_outcome == idx:
			#gpu_particles_2d.set_emitting(true)

func _on_selected_button_mouse_entered():  #TODO make the die only emit particles when its die value = victory
	#make die modulate color
	return
	if !is_selected:
		gpu_particles_2d.set_emitting(true)
	



func _on_selected_button_mouse_exited():
	#make die unmodulate color
	return
	gpu_particles_2d.set_emitting(false)




#
#func _on_animation_player_animation_finished(anim_name):
	#if anim_name == "roll":
		#dice_rolled.emit(dice_outcome)
>>>>>>> Stashed changes
