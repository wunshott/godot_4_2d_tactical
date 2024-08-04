extends Action

class_name Grapple

@export var attack_ratio: float #this is how much the player decides to pump into the attack dice pool
@export var defense_ratio: float #this is how much the player decides to pump into the defense dice pool


var attack_dice_size: int = int(min_stamina_dice_cost * attack_ratio) #int * float
var defense_dice_size: int = int(min_stamina_dice_cost * defense_ratio)
