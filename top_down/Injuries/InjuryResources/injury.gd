extends Resource

class_name Injury

@export var InjuryCategory: String # Armor, Stamina, Pip
@export var InjuryCategoryNumber: int # 0 = Armor, 1 = Stamina, 2 = Pip

@export var Limb: String #Arm, Head, Leg, Groin, Torso
@export var LimbNumber: int #0, 1, 2 ,3 ,4

@export var InjuryDescription: String #Description of what Happens

@export var InjuryType: String #one time, Next Turn Only, status effect, percent chance of effect ##TODO breakdown these categories


@export var NextTurnOnly: bool #this injury only lasts for next effect
@export var ChanceModifider: float #the modifier percent this injury applies
@export var PercentChance: float #if this injury is selected, the chance the effect happens
@export var NumberofTruns: int #how many turns does this last


@export var DismembermentOptions: Array #TODO how to pass unique dismember options to each limb
# arm = fingers
# leg = knee? toes
# head = eyes, nose, ears, lips

## TODO figure out how this gets passed to the stats.
