extends KinematicBody2D

var val = -1

export var status = "none"
export var new = true
export var offset_ = Vector2()
var tsize
var mpos=Vector2()
var gpos=Vector2()
var debug = false

var BUTTON_LEFT = 1
var BUTTON_RIGHT = 2
var offset_tile = Vector2(5, -14)
var orig_pos = Vector2()

var tween_rotation
var direction = 0
var size = 0
var glob
var spriterect
var tile_pos = false
export var arms = 1


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	glob = get_node("/root/GlobalVariables")
	tween_rotation = get_node("Tween")
	tsize = $PickArea.get_size()
	pass # Replace with function body.


func _process(delta):
	if status == "dragging" and not new:
		#print("dragging")
		if debug:
			debug=false
		
		position = get_global_mouse_position() + offset_
		self.global_position = position
		#print(self.rect_global_position)
		
	elif new:
		# Fix for dragging the arm from the spawn button
		debug = true
		offset_ = position - get_global_mouse_position()
		new=false

func get_snapping_pos():
	var mouse_pos = get_node("/root/main/Tiles/Tilemap").world_to_map(get_global_mouse_position())
	self.global_position = get_node("/root/main/Tiles/Tilemap").map_to_world(mouse_pos)
	self.global_position = 	self.rect_global_position+offset_tile
	

func set_position_with_offset(pos):
	self.global_position = pos + offset_tile
	
func update_pos(diff):
	self.global_position = self.global_position + diff
	
func dropped():
	var success = glob.add_arm(self)
	if not success:
		self.queue_free()
	update_rect()
	status="released"

func update_rect():
	gpos=self.global_position
	spriterect = Rect2(gpos.x, gpos.y, tsize.x, tsize.y)
	
func grabbed(pos):
	if spriterect.has_point(pos):
		status="clicked"
		offset_=gpos-pos
	
		glob.remove_arm(self.tile_pos)



func _input(ev):

	if ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT and ev.is_pressed() and (status != "dragging" or new==true):
		grabbed(ev.position)

	if status=="clicked" and ev is InputEventMouseButton :
		status="dragging"

	if status=="dragging" and ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT:
		if not ev.is_pressed():
			dropped()

	mpos=ev.global_position

	if ev is InputEventMouseButton  and ev.button_index == BUTTON_RIGHT and not tween_rotation.is_active():
		tween_rotation.interpolate_property(self, "rect_rotation", direction* 60, (direction+1) * 60, 1)
		tween_rotation.start()
		direction += 1
		pass



