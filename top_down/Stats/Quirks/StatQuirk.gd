extends Resource

class_name StatQuirk

#make a resource file for the stat perks (perk name, stat boon, stat reduction, point cost)

@export var name: String

@export var stat_change_dictionary: Dictionary = {
	"Vitality": -1,
	"Coordination": 1,
	"Eloquence": 0,
	"Brilliance": 0,
	"Intuition": 0,
	"Empathy": 0,
	
	}

@export var point_cost: int
