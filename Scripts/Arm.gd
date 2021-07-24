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
var handler
var spriterect
var tile_pos = false
export var arms = 1
export var arm_length = 1
var orig_z

var map_reach = null
var grabbed_atoms = []

var old_rot

# Called when the node enters the scene tree for the first time.
func _ready():
	glob = get_node("/root/GlobalVariables")
	handler = get_node("/root/ArmHandler")
	tween_rotation = get_node("Tween")
	tsize = $PickArea.get_size()
	orig_z = self.z_index

	pass # Replace with function body.
	
	
func update_reach_maps():
	self.map_reach = glob.create_reach(self.tile_pos, self.arm_length)
	
	
				
func get_ring_positions():
	
	if arms == 1:
		return [map_reach[direction]]
	if arms == 2:
		return [map_reach[direction], map_reach[(direction+3)%6]]
	if arms == 3:
		return [map_reach[direction], map_reach[(direction+2)%6], map_reach[(direction+2)%6]]
	if arms == 6:
		return [map_reach[direction], map_reach[(direction+1)%6], map_reach[(direction+2)%6], 
				map_reach[(direction+3)%6], map_reach[(direction+4)%6], map_reach[(direction+5)%6]]
				
func grab_atoms():
	
	for pos in get_ring_positions():
		var atom = handler.grab_atoms(pos)
		if atom:
			grabbed_atoms.append(atom)
	
	for atom in grabbed_atoms:
		atom.remove_self()
			
func release_atoms():
	grabbed_atoms = []
		



func _process(delta):
	if status == "dragging" and not new:
		if debug:
			debug=false
		
		position = get_global_mouse_position() + offset_
		self.global_position = position
		
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
	var success = handler.add_arm(self)
	if not success:
		self.queue_free()
	update_rect()
	update_reach_maps()	
	self.z_index = orig_z
	status="released"


func update_rect():
	gpos=self.global_position
	spriterect = Rect2(gpos.x, gpos.y, tsize.x, tsize.y)

func is_in_image(pos):
	var space_state = $ArmPickArea.get_world_2d().direct_space_state
	var result = space_state.intersect_point(pos)

	for x in result:
		if x["collider_id"] == self.get_instance_id():
			return true
	return false

func grabbed(pos):
	if is_in_image(pos):
		status="clicked"
		offset_=gpos-pos
		self.z_index = 1000
		handler.remove_arm(self.tile_pos)
	

func rotate(clockwise=1):
	var final = direction + clockwise
	old_rot = deg2rad(-direction * 60)
	tween_rotation.interpolate_property($ArmImage, "rect_rotation", -direction* 60, -(final) * 60, 1)
	tween_rotation.start()
	direction = final % 6
	
	
	
func _input(ev):

	if ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT and ev.is_pressed() and (status != "dragging" or new==true):
		grabbed(ev.position)

	if status=="clicked" and ev is InputEventMouseButton :
		status="dragging"

	if status=="dragging" and ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT:
		if not ev.is_pressed():
			dropped()

	mpos=ev.global_position

	if ev is InputEventMouseButton  and ev.button_index == BUTTON_RIGHT and not tween_rotation.is_active() and ev.is_pressed():
		grab_atoms()
		rotate(1)
		
		





func _on_Tween_tween_step(object, key, elapsed, value):
	var new_rot = deg2rad(value)
	var delta = Vector2(cos(new_rot)-cos(old_rot), 
					sin(new_rot)-sin(old_rot))
	for atom in grabbed_atoms:
		var dist = atom.global_position - self.global_position
		atom.global_position += (delta * (dist.length()))
	old_rot = new_rot


func _on_Tween_tween_completed(object, key):
	for atom in grabbed_atoms:
		atom.dropped("arm_move")
	release_atoms()
	get_ring_positions()
	
