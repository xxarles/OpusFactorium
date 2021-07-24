extends KinematicBody2D


var direction = 0
var tile_pos = false
var all_tiles
var status
var glob
var gpos
var spriterect
var tsize
var offset_ = Vector2(-35,-35)
var offset_tile = Vector2(0,-24)
var new = true
var dropped_once = false
var mpos
var handler
var orig_z


# Called when the node enters the scene tree for the first time.
func _ready():
	glob = get_node("/root/GlobalVariables")
	handler = get_node("/root/ProjectionGlyphHandler")
	gpos = self.global_position
	orig_z = self.z_index


func _process(delta):
	if status == "dragging" and not new:
		var final_position = get_global_mouse_position() + offset_
		self.global_position = final_position
		
	elif new:
		# Fix for dragging the arm from the spawn button
		offset_ = delta
		offset_ = position - get_global_mouse_position()
		new=false
	
		
func get_proper_rect(ctrl_node):
	gpos=ctrl_node.global_position
	return Rect2(gpos.x, gpos.y, tsize.x, tsize.y)
		
func dropped():
	#ADD YOUR TILE 
	status="released"
	self.z_index = orig_z
	dropped_once = true
	if not handler.add_projection_glyph(self):
		self.queue_free()

func set_position_with_offset(pos):
	self.global_position = pos + offset_tile

func is_in_image(pos):
	var space_state = $ProjectionGlyphArea.get_world_2d().direct_space_state
	var result = space_state.intersect_point(pos)
	if len(result)==1:
		if result[-1]["collider_id"] == self.get_instance_id():
			return true
	return false

func grabbed(pos):
	if is_in_image(pos):
		status="clicked"
		offset_=gpos-pos
		self.z_index = 1000
		handler.remove_tile(all_tiles)
	
	###REMOVE TILEglob.remove_arm(self.tile_pos)


func _input(ev):

	if ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT and ev.is_pressed() and (status != "dragging" or new==true):
		gpos = self.global_position
		grabbed(ev.position)

	if status=="clicked" and ev is InputEventMouseButton :
		status="dragging"

	if status=="dragging" and ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT:
		if not ev.is_pressed():
			dropped()

	mpos=ev.global_position
	

	mpos=ev.global_position
	pass # Replace with function body.
