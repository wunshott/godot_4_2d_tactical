@tool
extends RichTextEffect
class_name RichtTextSparkle

# Syntax: [sparkle freq c1 c2 c3][/sparkle]
var bbcode = "sparkle"



func _process_custom_fx(char_fx: CharFXTransform):
	var colors = char_fx.env.get("colors", ["red"])
	var color_pos = (char_fx.range.x + int(sin(char_fx.elapsed_time * 5.5) + 1) ) % len(colors)
	char_fx.color = colors[color_pos]
	return true
