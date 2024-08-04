extends PanelContainer

class_name SelectedStatMenu


@onready var stat_description_rtl = $VBoxContainer/StatDescriptionRTL as RichTextLabel


var stat_displayed : StatDisplayed
enum StatDisplayed {Vitality, Coordination, Eloquence, Brilliance, Intuition, Empathy}

#TODO move all this to a resource file?
#TODO what about the general description of the stat?
#TODO load all quirks in the quirk folde into here:

@onready var stat_quirk_container = $VBoxContainer/PanelContainer/StatQuirkVBoxContainer/ScrollContainer/VBoxContainer


var VitalityDescription: String = "Vitality is your measure of physical health. A character with a large vitality
is healthy, strong and a high endurance"
#affects lifting, pushing, strength, health, stmina
#gives bonus to limb die?
var CoordinationDescription: String = "Coordination is a measure of your manual dexterity. Your ability to use your body.
A character with a high coordination is nimble and has fine control over objects that they manipulate"
#affects your ability to react in combat (initiative, dodge)
# gives bonus to arm and leg dice?

var EloquenceDescription: String = "Eloquence is a measure of your ability to express yourself and influence people with words.
Most people react positively to a character with high eloquence"
# gives bonus to head and face dice
# affects speech skills

var BrillianceDescription: String = "Brilliance conveys a character's ability to learn and master scholarly subjects from different
fields. A brilliant character can be a human encyclopedia"

var IntuitionDescription: String = "Intuition represents a person's capacity to understand the world based on 
instinct. A highly intuitive person resists outward influencs. They have a better grasp at synthesizing knowledge for 
a pragmatic use over a pure scientist"

var EmpathyDescription: String = "Empathy describes a cahracter's understanding of the motives, thoughts, feelings and subconscious
desires of the world around them. A highly empathic person can deduce motivations unknown to the target."

var VitalityDictionary: Dictionary = {
	1: "Consumptive Invalid: Frail as a leaf in autumn's chill",
	2: "Pallid Wretch: Thy vigor is meage; thou dost tire easily and suffer from frequeny maladies",
	3: "Feeble Invalid: Thy frame is slight and tho art often beset by weariness",
	4: "Frail Soul: Thou art of average health, neither robust nor frail",
	5: "Common Man",
	6: "Sturdy Peasant",
	7: "Robust Fellow",
	8: "Stalwart Guardian",
	9: "Indomitabel Titan",
	10: "Herculean Colossus",
	11: "Immortal Champion",
	12: "Eternal Demigod",
}
var CoordinationDictionary: Dictionary = {
	1: "Ham-Fisted Oaf",
	2: "Bumbling Fool",
	3: "Ungainly Simpleton",
	4: "Mediocre Chap",
	5: "Steady Hand",
	6: "Agile Artisan",
	7: "Nimble Performer",
	8: "Dexterous Virtuoso",
	9: "Masterful Acrobat",
	10: "Legendary Artisan",
	11: "Preternatural Contortionist",
	12: "Divine Maestro",
}

var EloquenceDictionary: Dictionary = {
	1: "Inarticulate Peasant",
	2: "Mumbling Serf",
	3: "Halting Orator",
	4: "Plain Speaker",
	5: "Competent Rhetorician",
	6: "Persuasive Speaker",
	7: "Eloquent Diplomat",
	8: "Charismatic Leader",
	9: "Magnetic Preacher",
	10: "Silver-Tongued Bard",
	11: "Hypnotic Orator",
	12: "Divine Herald",
}

var BrillianceDictionary: Dictionary = {
	1: "Dullard",
	2: "Thick-Headed",
	3: "Slow Thinker",
	4: "Average Intellect",
	5: "Sharp Intellect",
	6: "Learned Scholar",
	7: "Brilliant Thinker",
	8: "Astute Genius",
	9: "Erudite Savant",
	10: "Prodigious Mind",
	11: "Transcendent Intellect",
	12: "Omniscient Sage",
}

var IntuitionDictionary: Dictionary = {
	1: "Oblivious Bumbler - Unaware of surroundings.",
	2: "Unaware Simpleton - Misses obvious details.",
	3: "Unobservant Peasant - Often overlooks important things.",
	4: "Cautious Observer - Moderately perceptive.",
	5: "Perceptive Commoner - Notices more than most.",
	6: "Insightful Thinker - Understands underlying truths.",
	7: "Keen Visionary - Highly perceptive and aware.",
	8: "Discerning Oracle - Sees hidden truths clearly.",
	9: "Intuitive Seer- Almost instinctively aware.",
	10: "Clairvoyant Sage - Perceives beyond the ordinary.",
	11: "Prophetic Visionary - Foresees events with clarity.",
	12: "Omniscient Watcher - Aware of all that is and will be.",
}

var EmpathyDictionary: Dictionary = {
	1: "Aloof Misfit - Disconnected from others' feelings.",
	2: "Detached Hermit - Lacks emotional connection.",
	3: "Insensitive Brute - Uncaring and unfeeling.",
	4: "Understanding Companion - Moderately empathetic.",
	5: "Empathetic Confidant - Feels and understands others.",
	6: "Compassionate Healer - Deeply cares for others' well-being.",
	7: "Sympathetic Advisor - Provides emotional support.",
	8: "Intuitive Counselor - Easily understands emotional states.",
	9: "Sensitive Empath - Deeply in tune with others' emotions.",
	10: "Soulful Sage - Profoundly connected to others.",
	11: "Telepathic Guide - Reads and feels thoughts and emotions.",
	12: "Divine Conduit - Perfectly bridges souls and hearts.",
}




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func display_stat(value: int) -> void:
	
	if stat_displayed == StatDisplayed.Vitality:
		stat_description_rtl.clear()
		stat_description_rtl.add_text(VitalityDescription)
	elif stat_displayed == StatDisplayed.Coordination:
		stat_description_rtl.clear()
		stat_description_rtl.add_text(CoordinationDescription)
	elif stat_displayed == StatDisplayed.Eloquence:
		stat_description_rtl.clear()
		stat_description_rtl.add_text(EloquenceDescription)
	elif stat_displayed == StatDisplayed.Brilliance:
		stat_description_rtl.clear()
		stat_description_rtl.add_text(BrillianceDescription)
	elif stat_displayed == StatDisplayed.Intuition:
		stat_description_rtl.clear()
		stat_description_rtl.add_text(IntuitionDescription)
	elif stat_displayed == StatDisplayed.Empathy:
		stat_description_rtl.clear()
		stat_description_rtl.add_text(EmpathyDescription)
	
	return
