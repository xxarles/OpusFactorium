extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var atom_type = "earth"
var all_types = ['copper', 'gold', 'iron', 'lead', "mors", "quicksilver", "salt", 'silver', 'vitae']
var val = -1

export var status = "none"
export var new = true
export var offset_ = Vector2()
var tsize=Vector2()
var mpos=Vector2()
var gpos=Vector2()
var debug = false

var BUTTON_LEFT = 1
var offset_tile = Vector2(5, -14)
var orig_pos = Vector2()
var pos_dict = {}
var tile_pos = false
var glob
var spriterect


# Called when the node enters the scene tree for the first time.
func _ready():
	glob = get_node("/root/GlobalVariables")
	tsize=$Image.get_size()
	set_process_input(true)
	set_process(true)
	update_rect()
	
	update_type(all_types[val])
	
func update_type(new_type):
	if new_type == atom_type:
		return
	atom_type = new_type
	
	if atom_type in ['earth', 'air', 'fire', 'water']:
		$Image/shadow.texture = load("res://assets/textures/atoms/elements/" + atom_type + "_shadow.png")
		$Image/base.texture = load("res://assets/textures/atoms/elements/" + atom_type + "_base.png")
		$Image/base2.texture = load("res://assets/textures/atoms/elements/" + atom_type + "_base2.png") 
		$Image/fog.texture = load("res://assets/textures/atoms/elements/" + atom_type + "_fog.png" )
		$Image/symbol.texture = load("res://assets/textures/atoms/elements/" + atom_type + "_symbol.png" )
		
	elif atom_type in ['copper', "mors", "salt", 'vitae',  'gold', 'iron',"quicksilver", 'silver', 'lead']:
		if atom_type in [ 'gold', 'iron',"quicksilver", 'silver', 'lead']:
			$Image/base.texture = load("res://assets/textures/atoms/mors_diffuse.png")
			$Image/base2.texture = load("res://assets/textures/atoms/mors_diffuse.png") 
		else:
			$Image/base.texture = load("res://assets/textures/atoms/" + atom_type + "_diffuse.png")
			$Image/base2.texture = load("res://assets/textures/atoms/" + atom_type + "_diffuse.png") 			
			
		$Image/shadow.texture = load("res://assets/textures/atoms/shadow.png")
		$Image/fog.texture = load("res://assets/textures/atoms/" + atom_type + "_shade.png" )
		$Image/symbol.texture = load("res://assets/textures/atoms/" + atom_type + "_symbol.png" )
		
	
	pass # Replace with function body.
		
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Image_mouse_entered():
	val +=1
	val %= len(all_types)
	update_type(all_types[val])
	pass # Replace with function body.
	
	

func _process(delta):
	if status == "dragging" and new == false:
		if debug:
			debug=false
		
		position = get_global_mouse_position() + offset_
		#self.global_position = offset_
		
	elif new:
		offset_ = position - get_global_mouse_position()
		new=false

	
func set_position_with_offset(pos):
	self.global_position = pos + offset_tile
	
func update_pos(diff):
	self.global_position = self.global_position + diff
	
func dropped(type="mouse"):
	var success = glob.add_atom(self, type)
	if not success:
		self.queue_free()
	else:
		pass
	update_rect()
	status="released"

func update_rect():
	gpos=self.global_position
	spriterect = Rect2(gpos.x, gpos.y, tsize.x, tsize.y)
	
func grabbed(pos):
	gpos=self.global_position		
	if spriterect.has_point(pos):
		status="clicked"
		offset_=gpos-pos
		glob.remove_atom(self)
	

func _input(ev):
	if ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT and ev.is_pressed() and (status != "dragging" or new==true):
		grabbed(ev.position)

	if status=="clicked" and ev is InputEventMouseButton :
		status="dragging"

	if status=="dragging" and ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT:
		if not ev.is_pressed():
			dropped()
			
				
	mpos=ev.global_position


