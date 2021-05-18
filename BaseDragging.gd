extends Area2D


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
	#tsize = $CollisionShape2D.
	pass # Replace with function body.
	
func _process(delta):
	if status == "dragging" and new == false:
		position = get_global_mouse_position() + offset_
		
	elif new:
		offset_ = position - get_global_mouse_position()
		new=false

func dropped():
	#ADD YOUR TILE var success = glob.add_arm(self)
#	if not success:
#		self.queue_free()
	status="released"
	dropped_once = true


func grabbed(pos):
	status="clicked"
	offset_=global_position-pos
	###REMOVE TILEglob.remove_arm(self.tile_pos)


func _on_ProjectionGlyph_input_event(viewport, ev, shape_idx):
	print("EVENT")
	print(status)
	print(ev)
	if ev is InputEventMouseButton:
		print(ev.button_index == BUTTON_LEFT)
		
		if ev.button_index == BUTTON_LEFT and ev.is_pressed() and (status != "dragging" or new==true):
			print("GRABBED")
			grabbed(ev.position)
			status="dragging"
			

		if ev.button_index == BUTTON_LEFT:
			print("testing!")
			if not ev.is_pressed():
				print("DROPPING")
				dropped()
	
	if not dropped_once and not new:
		dropped()

	mpos=ev.global_position
	pass # Replace with function body.
