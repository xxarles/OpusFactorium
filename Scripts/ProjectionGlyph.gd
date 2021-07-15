extends KinematicBody2D


var direction = 0
var tile_pos
var status
var glob
var gpos
var spriterect
var tsize
var offset_ = Vector2(-35,-35)
var new = true
var dropped_once = false
var mpos


# Called when the node enters the scene tree for the first time.
func _ready():
	glob = get_node("/root/GlobalVariables")
	gpos = self.global_position
	#"Instaiation on positon:")
	#print(self.global_position)
	#tsize = $CollisionShape2D.
	pass # Replace with function body.
	
func _process(delta):
	
	if status == "dragging" and not new:
		var final_position = get_global_mouse_position() + offset_
		self.global_position = final_position
		#print(self.rect_global_position)
		
	elif new:
		# Fix for dragging the arm from the spawn button
		offset_ = position - get_global_mouse_position()
		new=false
	
		
func get_proper_rect(ctrl_node):
	gpos=ctrl_node.global_position
	return Rect2(gpos.x, gpos.y, tsize.x, tsize.y)
		
func is_in_image(pos):
	var space_state = $MyArea.get_world_2d().direct_space_state
	var result = space_state.intersect_point(pos)
	print("Checking if in image!")
	print(result)
	print($MyArea.get_instance_id())
	print(self)
	for x in result:
		if x["collider_id"] == self.get_instance_id():
			return true
	
	
	#return true
	return false

func dropped():
	#ADD YOUR TILE 
	print("Changing status!!")
	status="released"
	dropped_once = true


func grabbed(pos):
	if is_in_image(pos):
		print("Clicked!")
		print(gpos, self.global_position, self.get_global_mouse_position(), pos)
		status="clicked"
		offset_=gpos-pos
		#glob.remove_arm(self.tile_pos)
	
	###REMOVE TILEglob.remove_arm(self.tile_pos)


func _input(ev):

	if ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT and ev.is_pressed() and (status != "dragging" or new==true):
		print("grabbin!")
		gpos = self.global_position
		grabbed(ev.position)

	if status=="clicked" and ev is InputEventMouseButton :
		status="dragging"

	if status=="dragging" and ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT:
		print("trying to drop")
		if not ev.is_pressed():
			dropped()

	mpos=ev.global_position
	
	if not dropped_once and not new:
		dropped()

	mpos=ev.global_position
	pass # Replace with function body.
