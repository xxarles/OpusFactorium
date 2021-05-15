extends Node2D

export var real_pos = Vector2()
signal pos_changes

var status = "none"
var BUTTON_MIDDLE = 3
var offset_ = Vector2()
var evpos
var gpos
var t_map
var tilling
var shades
var gvars


func _ready():
	t_map= get_node("./Tilemap")
	tilling = get_node("./Tilling")
	shades = get_node("./Shades")


func _process(delta):
	if status == "dragging":

		var new_pos = evpos - self.get_global_mouse_position()
		real_pos = real_pos - new_pos
		shades.global_position =  Vector2(int(real_pos.x)%(82*10), int(real_pos.y)%(71*10))
		tilling.global_position =  Vector2(int(real_pos.x)%(82*10), int(real_pos.y)%(71*10))
		t_map.global_position =  real_pos
		emit_signal("pos_changes", -new_pos)
		evpos = self.get_global_mouse_position()
		#gvars.update_all_pos(- new_pos)
		
		
	
		

func _input(ev):
	if ev is InputEventMouseButton  and ev.button_index == BUTTON_MIDDLE and ev.is_pressed() and (status != "dragging"):
		evpos=ev.global_position
		status="clicked"

	if status=="clicked" and ev is InputEventMouseButton :
		status="dragging"

	if status=="dragging" and ev is InputEventMouseButton  and ev.button_index == BUTTON_MIDDLE:
		if not ev.is_pressed():
			
			status="released"

