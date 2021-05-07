extends Control

signal spawn_atom

var val = -1

export var status = "none"
export var new = true
export var offset_ = Vector2()
var tsize=self.rect_size
var mpos=Vector2()
var position=Vector2()
var gpos=Vector2()
var debug = false

var BUTTON_LEFT = 1
var BUTTON_RIGHT = 2
var offset_tile = Vector2(5, -14)
var orig_pos = Vector2()

var tween_rotation
var direction = 0
var size = 0
export var arms = 1


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	tween_rotation = get_node("Tween")
	pass # Replace with function body.


func _process(delta):
	if status == "dragging" and not new:
		print("dragging")
		if debug:
			debug=false
		
		position = get_global_mouse_position() + offset_
		self.rect_global_position = position
		print(self.rect_global_position)
		
	elif new:
		debug = true
		offset_ = position - get_global_mouse_position()
		new=false

func get_snapping_pos():
	var mouse_pos = get_node("/root/main/Tiles/Tilemap").world_to_map(get_global_mouse_position())
	self.rect_global_position = get_node("/root/main/Tiles/Tilemap").map_to_world(mouse_pos)
	self.rect_global_position = 	self.rect_global_position+offset_tile
	
	

func _input(ev):
		
	if ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT and ev.is_pressed() and (status != "dragging" or new==true or debug):
		var evpos=ev.position
		gpos=self.rect_global_position
		var spriterect
		print(gpos)
		print(tsize)
		spriterect=Rect2(gpos.x, gpos.y, tsize.x, tsize.y)
			
		if spriterect.has_point(evpos):
			status = "clicked"
			print("CLICKED")
			offset_=gpos-evpos

	if status=="clicked" and ev is InputEventMouseButton :
		print("drag_start")
		status="dragging"

	if status=="dragging" and ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT:
		if not ev.is_pressed():
			status="released"
			get_snapping_pos()

	mpos=ev.global_position
	
	if ev is InputEventMouseButton  and ev.button_index == BUTTON_RIGHT and not tween_rotation.is_active():
		tween_rotation.interpolate_property(self, "rect_rotation", direction* 60, (direction+1) * 60, 1)
		tween_rotation.start()
		direction += 1
		pass
