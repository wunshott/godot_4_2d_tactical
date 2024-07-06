@tool
extends RichTextEffect
class_name RichTextHeart

# Syntax: [heart scale=1.0 freq=8.0][/heart]
var bbcode = "heart"

var HEART = "♡".unicode_at(0) as int
var TO_CHANGE = ["o".unicode_at(0), "O".unicode_at(0), "a".unicode_at(0),"A".unicode_at(0)]

func get_text_server():
	return TextServerManager.get_primary_interface()

func _process_custom_fx(char_fx):
	var scale:float = char_fx.env.get("scale", 16.0)
	var freq:float = char_fx.env.get("freq", 2.0)
	

	var x =  char_fx.glyph_index  / scale - char_fx.elapsed_time * freq
	var t = abs(cos(x)) * max(0.0, smoothstep(0.712, 0.99, sin(x))) * 2.5;
	char_fx.color = lerp(char_fx.color, lerp(Color.BLUE, Color.RED, t), t)
	char_fx.offset.y -= t * 4.0
	
	var value = char_fx.glyph_index
	#var c = char_fx.character
	#if char_fx.offset.y < -1.0:
	if char_fx.glyph_index in TO_CHANGE:
		#print(get_text_server().font_get_glyph_index(char_fx.font, 1, value, 0))
		char_fx.glyph_index = HEART
	#if the glyph is a c, replace with heart
		char_fx.glyph_index = get_text_server().font_get_glyph_index(char_fx.font, 1, value, 0)
	return true
