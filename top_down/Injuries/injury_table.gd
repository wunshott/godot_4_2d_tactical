extends Node



signal _injury_for_combat_dialogue_box(injury_name: String, limb: String)

@export var MasterInjuryArray: Array[Injury]



var InjuryDict: Dictionary = {
	"Head":{
	"Armor": [],
	"Stamina":[],
	"Pip": [],
	},
	
	"Torso":{
	"Armor": [],
	"Stamina":[],
	"Pip": [],
	},
	
	"Arm":{
	"Armor": [],
	"Stamina":[],
	"Pips": [],
	},
	
	"Leg":{
	"Armor": [],
	"Stamina":[],
	"Pip": [],
	},
	
	"Groin":{
	"Armor": [],
	"Stamina":[],
	"Pip": [],
	},
	
}

func _ready():
	_populate_injury_dict(InjuryDict,MasterInjuryArray)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _populate_injury_dict(InjuryDict:Dictionary, InjuryArray:Array[Injury]):
	for injury in InjuryArray:
		if injury.Limb == "Head":
			if injury.InjuryCategory == "Armor":
				InjuryDict.get("Head").get("Armor").append(injury)
			if injury.InjuryCategory == "Stamina":
				InjuryDict.get("Head").get("Stamina").append(injury)
			if injury.InjuryCategory == "Pip":
				InjuryDict.get("Head").get("Pip").append(injury)
		if injury.Limb == "Torso":
			if injury.InjuryCategory == "Armor":
				InjuryDict.get("Torso").get("Armor").append(injury)
			if injury.InjuryCategory == "Stamina":
				InjuryDict.get("Torso").get("Stamina").append(injury)
			if injury.InjuryCategory == "Pip":
				InjuryDict.get("Torso").get("Pip").append(injury)
	
func _roll_arm_injury_table(limb: String, DamageType: String): 
	#come up with a clean way to access the injury table
	var array_to_roll: Array[Injury] 
	array_to_roll.append_array(InjuryDict.get(limb).get(DamageType)) #rolls the injury table associated with the limb and defense type (armor, limb, pip)
	var injury_roll_outcome = randi_range(0,array_to_roll.size()-1)
	
	_injury_for_combat_dialogue_box.emit("Target's " + str(limb) + " was inflicted with " + str(array_to_roll[injury_roll_outcome].InjuryDescription), 0) #TODO print to the dialogue window
	#TODO replace target with the node name
	return array_to_roll[injury_roll_outcome]
	

